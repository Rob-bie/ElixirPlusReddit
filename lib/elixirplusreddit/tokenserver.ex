defmodule ElixirPlusReddit.TokenServer do
  use GenServer

  @moduledoc """
  Handles distrubuting and acquiring access tokens.

  ### Details
  
  A new token is automatically
  acquired every 58 minutes. It is possible to manually acquire tokens but should
  only be used when a request returns with the status code 401. (Expired token)
  """

  alias ElixirPlusReddit.API.Authentication

  @tokenserver    __MODULE__
  @token_interval  1000 * 60 * 58

  @doc """
  Start the token server. A token is acquired inside of init/1.
  """

  def start_link do
    GenServer.start_link(@tokenserver, [], name: @tokenserver)
  end

  @doc """
  Returns the current access token.
  """

  def token do
    GenServer.call(@tokenserver, :token)
  end

  @doc """
  Issues a new token manually.
  """

  # NOTE: The request is sent to the server with send so that it is handled by
  # the handle_info callback.

  def new_token do
    send(@tokenserver, :new_token)
  end

  def init(_) do
    token_state = Authentication.request_token
    schedule_token_request
    {:ok, token_state}
  end

  def handle_call(:token, _from, token_state) do
    {:reply, token_state, token_state}
  end

  def handle_info(:new_token, _token_state) do
    token_state = Authentication.request_token
    schedule_token_request
    {:noreply, token_state}
  end

  defp schedule_token_request do
    Process.send_after(@tokenserver, :new_token, @token_interval)
  end

end

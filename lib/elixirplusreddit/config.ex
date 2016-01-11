defmodule ElixirPlusReddit.Config do

  @moduledoc """
  An interface for accessing configuration data from config.exs.
  """

  @doc """
  Return credentials from config.exs. Credentials are stored as a
  keyword list:

  [
  username:      username,
  password:      password,
  client_id:     client_id,
  client_secret: client_secret
  ]
  """

  def credentials do
    Application.get_env(:elixirplusreddit, :creds)
  end

  @doc """
  Return the client's user agent.
  """

  def user_agent do
    Application.get_env(:elixirplusreddit, :user_agent)
  end

end

defmodule ElixirPlusReddit.API.Authentication do

  @moduledoc """
  Provides an interface for acquiring access tokens. Requesting a token
  is considered a special case and is NOT subject to rate limiting through
  the priority queue.
  """

  alias ElixirPlusReddit.Config
  alias ElixirPlusReddit.Request
  alias ElixirPlusReddit.Parser

  @token_endpoint "https://www.reddit.com/api/v1/access_token"


  @doc """
  Grants the client an access token.
  """

  def request_token do
    creds = Config.credentials
    body = [grant_type: "password", username: creds[:username], password: creds[:password]]
    basic_auth = [basic_auth: {creds[:client_id], creds[:client_secret]}]
    retry_until_success(@token_endpoint, body, basic_auth)
  end

  defp retry_until_success(endpoint, body, basic_auth) do
    {resp, strategy} = Request.request_token(@token_endpoint, body, basic_auth)
    case resp.status_code do
      c when c in 500..599 -> retry_until_success(endpoint, body, basic_auth)
      _ -> Parser.parse(resp, strategy)
    end
  end


end

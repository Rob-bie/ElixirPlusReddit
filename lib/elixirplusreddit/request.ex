defmodule ElixirPlusReddit.Request do

  alias ElixirPlusReddit.Parser
  alias ElixirPlusReddit.TokenServer
  alias ElixirPlusReddit.Config

  @moduledoc """
  A thin wrapper around HTTPotion's HTTP request function. All requests are processed inside
  of this module after being received from the request server.
  """

  def request_token(url, query, options) do
    options = [body: encode_post_query(query), headers: headers] |> Keyword.merge(options)
    {HTTPotion.request(:post, url, options), :token}
  end

  def request(:get, url, parse_strategy) do
    options = [headers: headers(:token_required)]
    {HTTPotion.request(:get, url, options), parse_strategy}
  end

  def request(:get, url, query, parse_strategy) do
    url = encode_get_query(url, query)
    options = [headers: headers(:token_required)]
    {HTTPotion.request(:get, url, options), parse_strategy}
  end

  def request(:post, url, query, parse_strategy) do
    options = [body: encode_post_query(query), headers: headers(:token_required)]
    {HTTPotion.request(:post, url, options), parse_strategy}
  end

  defp headers(:token_required) do
    ["Authorization": TokenServer.token] |> Keyword.merge(headers)
  end

  defp headers do
    ["Content-Type": "application/x-www-form-urlencoded",
     "User-Agent": Config.user_agent]
  end

  defp encode_get_query(url, query) do
    "#{url}?#{URI.encode_query(query)}"
  end

  defp encode_post_query(query) do
    URI.encode_query(query)
  end

end

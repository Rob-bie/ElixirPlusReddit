defmodule ElixirPlusReddit.API.Identity do

  @moduledoc """
  An interface for getting information about the authenticated user.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder

  @identity_base   "https://oauth.reddit.com/api/v1/me"
  @default_priority 0

  def me(from, tag, priority \\ @default_priority) do
    request_data = RequestBuilder.format_get(from, tag, @identity_base, :ok, priority)
    RequestServer.enqueue_request(request_data)
  end

  def prefs(from, tag, priority \\ @default_priority) do
    url = "#{@identity_base}/prefs"
    request_data = RequestBuilder.format_get(from, tag, url, :ok, priority)
    RequestServer.enqueue_request(request_data)
  end

  def trophies(from, tag, priority \\ @default_priority) do
    url = "#{@identity_base}/trophies"
    request_data = RequestBuilder.format_get(from, tag, url, :ok, priority)
    RequestServer.enqueue_request(request_data)
  end

end

defmodule ElixirPlusReddit.API.User do

  @moduledoc """
  An interface for getting user information.
  """

  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.RequestServer

  @user_base "https://oauth.reddit.com/user"
  @default_priority 0

  def comments(from, tag, username, options, priority) do
    listing(from, tag, username, options, :comments, priority)
  end

  def comments(from, tag, username, options) when is_list(options) do
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def comments(from, tag, username, priority) do
    listing(from, tag, username, [], :comments, priority)
  end

  defp listing(from, tag, username, options, endpoint, priority) do
    url = "#{@user_base}/#{username}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestServer.enqueue_request(request_data)
  end

end

defmodule ElixirPlusReddit.API.User do

  @moduledoc """
  An interface for getting user information.
  """

  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.Scheduler

  @user      __MODULE__
  @user_base "https://oauth.reddit.com/user"
  @default_priority 0

  def comments(from, tag, username) do
    listing(from, tag, username, [], :comments, @default_priority)
  end

  def comments(from, tag, username, options, priority) do
    listing(from, tag, username, options, :comments, priority)
  end

  def comments(from, tag, username, options) when is_list(options) do
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def comments(from, tag, username, priority) do
    listing(from, tag, username, [], :comments, priority)
  end

  def stream_comments(from, tag, username, interval) do
    Scheduler.schedule(from, tag, {@user, :comments}, [username, [], @default_priority], interval)
  end

  def stream_comments(from, tag, username, options, interval) when is_list(options) do
    Scheduler.schedule(from, tag, {@user, :comments}, [username, options, @default_priority], interval)
  end

  def stream_comments(from, tag, username, priority, interval) do
    Scheduler.schedule(from, tag, {@user, :comments}, [username, [] , priority], interval)
  end

  def stream_comments(from, tag, username, options, priority, interval) do
    Scheduler.schedule(from, tag, {@user, :comments}, [username, options, priority], interval)
  end

  defp listing(from, tag, username, options, endpoint, priority) do
    url = "#{@user_base}/#{username}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestServer.enqueue_request(request_data)
  end

end

defmodule ElixirPlusReddit.API.Subreddit do

  @moduledoc """
  An interface for getting subreddit information.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.Scheduler

  @subreddit       __MODULE__
  @subreddit_base  "https://oauth.reddit.com/r"
  @default_priority 0

  def hot(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :hot, @default_priority)
  end

  def hot(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :hot, priority)
  end

  def hot(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :hot, @default_priority)
  end

  def hot(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :hot, priority)
  end

  def new(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :new, @default_priority)
  end

  def new(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :new, priority)
  end

  def new(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :new, @default_priority)
  end

  def new(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :new, priority)
  end

  def rising(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :rising, @default_priority)
  end

  def rising(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :rising, priority)
  end

  def rising(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :rising, @default_priority)
  end

  def rising(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :rising, priority)
  end

  def controversial(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :controversial, @default_priority)
  end

  def controversial(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :controversial, priority)
  end

  def controversial(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :controversial, @default_priority)
  end

  def controversial(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :controversial, priority)
  end

  def top(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :top, @default_priority)
  end

  def top(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :top, priority)
  end

  def top(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :top, @default_priority)
  end

  def top(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :top, priority)
  end

  def gilded(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :gilded, @default_priority)
  end

  def gilded(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :gilded, priority)
  end

  def gilded(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :gilded, @default_priority)
  end

  def gilded(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :gilded, priority)
  end

  def comments(from, tag, subreddit) do
    listing(from, tag, subreddit, [], :comments, @default_priority)
  end

  def comments(from, tag, subreddit, options, priority) do
    listing(from, tag, subreddit, options, :comments, priority)
  end

  def comments(from, tag, subreddit, options) when is_list(options) do
    listing(from, tag, subreddit, options, :comments, @default_priority)
  end

  def comments(from, tag, subreddit, priority) do
    listing(from, tag, subreddit, [], :comments, priority)
  end

  def stream_submissions(from, tag, subreddit, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :new}, [subreddit, [], @default_priority], interval)
  end

  def stream_submissions(from, tag, subreddit, options, interval) when is_list(options) do
    Scheduler.schedule(from, tag, {@subreddit, :new}, [subreddit, options, @default_priority], interval)
  end

  def stream_submissions(from, tag, subreddit, priority, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :new}, [subreddit, [] , priority], interval)
  end

  def stream_submissions(from, tag, subreddit, options, priority, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :new}, [subreddit, options, priority], interval)
  end

  def stream_comments(from, tag, subreddit, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :comments}, [subreddit, [], @default_priority], interval)
  end

  def stream_comments(from, tag, subreddit, options, interval) when is_list(options) do
    Scheduler.schedule(from, tag, {@subreddit, :comments}, [subreddit, options, @default_priority], interval)
  end

  def stream_comments(from, tag, subreddit, priority, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :comments}, [subreddit, [] , priority], interval)
  end

  def stream_comments(from, tag, subreddit, options, priority, interval) do
    Scheduler.schedule(from, tag, {@subreddit, :comments}, [subreddit, options, priority], interval)
  end

  defp listing(from, tag, subreddit, options, endpoint, priority) do
    url = "#{@subreddit_base}/#{subreddit}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestServer.enqueue_request(request_data)
  end

end

defmodule ElixirPlusReddit.API.User do

  @moduledoc """
  An interface for getting user information.
  """

  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.Paginator
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

  def submissions(from, tag, username) do
    listing(from, tag, username, [], :submitted, @default_priority)
  end

  def submissions(from, tag, username, options, priority) do
    listing(from, tag, username, options, :submitted, priority)
  end

  def submissions(from, tag, username, options) when is_list(options) do
    listing(from, tag, username, options, :submitted, @default_priority)
  end

  def submissions(from, tag, username, priority) do
    listing(from, tag, username, [], :submitted, priority)
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

  def stream_submissions(from, tag, username, interval) do
    Scheduler.schedule(from, tag, {@user, :submissions}, [username, [], @default_priority], interval)
  end

  def stream_submissions(from, tag, username, options, interval) when is_list(options) do
    Scheduler.schedule(from, tag, {@user, :submissions}, [username, options, @default_priority], interval)
  end

  def stream_submissions(from, tag, username, priority, interval) do
    Scheduler.schedule(from, tag, {@user, :submissions}, [username, [] , priority], interval)
  end

  def stream_submissions(from, tag, username, options, priority, interval) do
    Scheduler.schedule(from, tag, {@user, :submissions}, [username, options, priority], interval)
  end

  def paginate_comments(from, tag, username) do
    Paginator.paginate(from, tag, {@user, :comments}, [username, [limit: 1000], @default_priority])
  end

  def paginate_comments(from, tag, username, options) when is_list(options) do
    Paginator.paginate(from, tag, {@user, :comments}, [username, put_limit(options), @default_priority])
  end

  def paginate_comments(from, tag, username, priority) do
    Paginator.paginate(from, tag, {@user, :comments}, [username, [limit: 1000], priority])
  end

  def paginate_comments(from, tag, username, options, priority) do
    Paginator.paginate(from, tag, {@user, :comments}, [username, put_limit(options), priority])
  end

  def paginate_submissions(from, tag, username) do
    Paginator.paginate(from, tag, {@user, :submissions}, [username, [limit: 1000], @default_priority])
  end

  def paginate_submissions(from, tag, username, options) when is_list(options) do
    Paginator.paginate(from, tag, {@user, :submissions}, [username, put_limit(options), @default_priority])
  end

  def paginate_submissions(from, tag, username, priority) do
    Paginator.paginate(from, tag, {@user, :submissions}, [username, [limit: 1000], priority])
  end

  def paginate_submissions(from, tag, username, options, priority) do
    Paginator.paginate(from, tag, {@user, :submissions}, [username, put_limit(options), priority])
  end

  defp put_limit(options) do
    case Keyword.has_key?(options, :limit) do
      true  -> options
      false -> Keyword.put(options, :limit, 1000)
    end
  end

  defp listing(from, tag, username, options, endpoint, priority) do
    url = "#{@user_base}/#{username}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestServer.enqueue_request(request_data)
  end

end

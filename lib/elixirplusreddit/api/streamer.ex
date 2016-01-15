defmodule ElixirPlusReddit.API.Streamer do
  use GenServer

  @moduledoc """
  Provides a way to retrieve new listings on an interval.

  # Details

  This does not gaurantee that duplicates will be omitted across requests. As such,
  if you were targeting a resource that is unlikely to update often, use a larger
  interval and smaller limit.
  """
  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.API.User
  alias ElixirPlusReddit.API.Subreddit

  @streamer __MODULE__
  @default_priority 0

  def user_comments(from, tag, username, options, priority, interval) do
    start_link(:user_comments, from, tag, username, options, priority, interval)
  end

  def user_comments(from, tag, username, options, interval) when is_list(options) do
    start_link(:user_comments, from, tag, username, options, @default_priority, interval)
  end

  def user_comments(from, tag, username, priority, interval) do
    start_link(:user_comments, from, tag, username, [], priority, interval)
  end

  def subreddit_comments(from, tag, subreddit, options, priority, interval) do
    start_link(:subreddit_comments, from, tag, subreddit, options, priority, interval)
  end

  def subreddit_comments(from, tag, subreddit, options, interval) when is_list(options) do
    start_link(:subreddit_comments, from, tag, subreddit, options, @default_priority, interval)
  end

  def subreddit_comments(from, tag, subreddit, priority, interval) do
    start_link(:subreddit_comments, from, tag, subreddit, [], priority, interval)
  end

  def start_link(type, from, tag, descriptor, options, priority, interval) do
    config = [
      type: type,
      from: from,
      tag: tag,
      descriptor: descriptor,
      options: options,
      priority: priority,
      interval: interval
    ]

    GenServer.start_link(@streamer, config, [])
  end

  def init(config) do
    schedule_request(config[:type], 250)
    {:ok, config}
  end

  def handle_info({:next_request, :user_comments}, config) do
    User.comments(config[:from],
                  config[:tag],
                  config[:descriptor],
                  config[:options],
                  config[:priority])

    schedule_request(config[:type], config[:interval])
    {:noreply, config}
  end

  def handle_info({:next_request, :subreddit_comments}, config) do
    Subreddit.comments(config[:from],
                       config[:tag],
                       config[:descriptor],
                       config[:options],
                       config[:priority])

    schedule_request(config[:type], config[:interval])
    {:noreply, config}
  end

  defp schedule_request(type, interval) do
    Process.send_after(self, {:next_request, type}, interval)
  end

end

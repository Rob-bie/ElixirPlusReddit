defmodule ElixirPlusReddit.API.Identity do

  @moduledoc """
  An interface for getting information about the authenticated user.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.Scheduler

  @identity        __MODULE__
  @identity_base   "https://oauth.reddit.com/api/v1/me"
  @default_priority 0

  @doc """
  Get information about the authenticated user.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `priority`:  The request's priority. (Optional)

  ### Fields

      comment_karma
      created
      created_utc
      gold_creddits
      gold_expiration
      has_mail
      has_mod_mail
      has_verified_email
      hide_from_robots
      id
      inbox_count
      is_gold
      is_mod
      is_suspended
      link_karma
      name
      over_18
      suspension_expiration_utc
  """

  def self_data(from, tag, priority \\ @default_priority) do
    request_data = RequestBuilder.format_get(from, tag, @identity_base, :no_data, priority)
    RequestServer.enqueue_request(request_data)
  end

  @doc """
  Get the authenticated user's preferences.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `priority`:  The request's priority. (Optional)

  ### Fields

      highlight_controversial
      over_18
      enable_default_themes
      show_promote
      numsites
      private_feeds
      min_comment_score
      public_votes
      label_nsfw
      domain_details
      media
      hide_locationbar
      show_snoovatar
      show_flair
      monitor_mentions
      num_comments
      threaded_messages
      organic
      show_link_flair
      show_trending
      highlight_new_comments
      default_comment_sort
      compress
      min_link_score
      newwindow
      creddit_autorenew
      show_gold_expiration
      collapse_left_bar
      lang
      force_https
      media_preview
      store_visits
      no_profanity
      use_global_defaults
      content_langs
      hide_downs
      ignore_suggested_sort
      collapse_read_messages
      mark_messages_read
      research
      default_theme_sr
      threaded_modmail
      hide_ups
      clickgadget
      email_messages
      beta
      hide_ads
      show_stylesheets
      legacy_search
      public_server_seconds
      hide_from_robots
  """

  def prefs(from, tag, priority \\ @default_priority) do
    url = "#{@identity_base}/prefs"
    request_data = RequestBuilder.format_get(from, tag, url, :no_data, priority)
    RequestServer.enqueue_request(request_data)
  end

  @doc """
  Get a list of the authenticated user's trophies.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `priority`:  The request's priority. (Optional)

  ### Fields

      award_id
      description
      icon_40
      icon_70
      id
      name
      url
  """

  def trophies(from, tag, priority \\ @default_priority) do
    url = "#{@identity_base}/trophies"
    request_data = RequestBuilder.format_get(from, tag, url, :trophies, priority)
    RequestServer.enqueue_request(request_data)
  end

  @doc """
  Get information about the authenticated user on an interval. This is commonly used
  to check for periodically checking for new messages.

  ### Parameters

  * `interval`: A value in milliseconds.

  ### Other

  Refer to `Identity.self_data` documentation for other parameter and field information.
  """

  def stream_self_data(from, tag, interval) do
    Scheduler.schedule({@identity, :self_data}, [from, tag, @default_priority], interval)
  end

  def stream_self_data(from, tag, priority, interval) do
    Scheduler.schedule({@identity, :self_data}, [from, tag, priority], interval)
  end

end

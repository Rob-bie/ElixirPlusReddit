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

  @doc """
  Get a user's `hot` comments.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `username:` A username or id.
  * `options`:  The query. (Optional)
  * `priority`: The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

      after
      before
      modhash
      children:
          author_flair_css_class
          gilded
          body_html
          quarantine
          report_reasons
          stickied
          created
          score
          user_reports
          over_18
          controversiality
          link_id
          edited
          downs
          mod_reports
          author_flair_text
          created_utc
          parent_id
          body
          likes
          ups
          distinguished
          link_author
          removal_reason
          replies
          name
          archived
          link_title
          subreddit
          author
          subreddit_id
          saved
          num_reports
          id
          score_hidden
          approved_by
          link_url
          banned_by
  """

  def hot_comments(from, tag, username) do
    listing(from, tag, username, [sort: :hot], :comments, @default_priority)
  end

  def hot_comments(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :hot)
    listing(from, tag, username, options, :comments, priority)
  end

  def hot_comments(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :hot)
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def hot_comments(from, tag, username, priority) do
    listing(from, tag, username, [sort: :hot], :comments, priority)
  end

  @doc """
  Get a user's `new` comments.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `username:` A username or id.
  * `options`:  The query. (Optional)
  * `priority`: The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

      after
      before
      modhash
      children:
          author_flair_css_class
          gilded
          body_html
          quarantine
          report_reasons
          stickied
          created
          score
          user_reports
          over_18
          controversiality
          link_id
          edited
          downs
          mod_reports
          author_flair_text
          created_utc
          parent_id
          body
          likes
          ups
          distinguished
          link_author
          removal_reason
          replies
          name
          archived
          link_title
          subreddit
          author
          subreddit_id
          saved
          num_reports
          id
          score_hidden
          approved_by
          link_url
          banned_by
  """

  def new_comments(from, tag, username) do
    listing(from, tag, username, [sort: :new], :comments, @default_priority)
  end

  def new_comments(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, username, options, :comments, priority)
  end

  def new_comments(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def new_comments(from, tag, username, priority) do
    listing(from, tag, username, [sort: :new], :comments, priority)
  end

  @doc """
  Get a user's `top` comments.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `username:` A username or id.
  * `options`:  The query. (Optional)
  * `priority`: The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `t`:      hour, day, week, month, year, all
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

      after
      before
      modhash
      children:
          author_flair_css_class
          gilded
          body_html
          quarantine
          report_reasons
          stickied
          created
          score
          user_reports
          over_18
          controversiality
          link_id
          edited
          downs
          mod_reports
          author_flair_text
          created_utc
          parent_id
          body
          likes
          ups
          distinguished
          link_author
          removal_reason
          replies
          name
          archived
          link_title
          subreddit
          author
          subreddit_id
          saved
          num_reports
          id
          score_hidden
          approved_by
          link_url
          banned_by
  """

  def top_comments(from, tag, username) do
    listing(from, tag, username, [sort: :top], :comments, @default_priority)
  end

  def top_comments(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :top)
    listing(from, tag, username, options, :comments, priority)
  end

  def top_comments(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :top)
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def top_comments(from, tag, username, priority) do
    listing(from, tag, username, [sort: :top], :comments, priority)
  end

  @doc """
  Get a user's `controversial` comments.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `username:` A username or id.
  * `options`:  The query. (Optional)
  * `priority`: The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `t`:      hour, day, week, month, year, all
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

      after
      before
      modhash
      children:
          author_flair_css_class
          gilded
          body_html
          quarantine
          report_reasons
          stickied
          created
          score
          user_reports
          over_18
          controversiality
          link_id
          edited
          downs
          mod_reports
          author_flair_text
          created_utc
          parent_id
          body
          likes
          ups
          distinguished
          link_author
          removal_reason
          replies
          name
          archived
          link_title
          subreddit
          author
          subreddit_id
          saved
          num_reports
          id
          score_hidden
          approved_by
          link_url
          banned_by
  """

  def controversial_comments(from, tag, username) do
    listing(from, tag, username, [sort: :controversial], :comments, @default_priority)
  end

  def controversial_comments(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :controversial)
    listing(from, tag, username, options, :comments, priority)
  end

  def controversial_comments(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :controversial)
    listing(from, tag, username, options, :comments, @default_priority)
  end

  def controversial_comments(from, tag, username, priority) do
    listing(from, tag, username, [sort: :controversial], :comments, priority)
  end

  @doc """
  Get a user's `hot` submissions.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `subreddit`: A subreddit name or id.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing
 
  ### Fields

      after
      before
      modhash
      children:
          link_flair_css_class
          author_flair_css_class
          thumbnail
          gilded
          quarantine
          report_reasons
          selftext_html
          stickied
          domain
          created
          score
          num_comments
          secure_media_embed
          user_reports
          over_18
          suggested_sort
          url
          edited
          downs
          mod_reports
          author_flair_text
          hide_score
          created_utc
          from_kind
          likes
          is_self
          ups
          distinguished
          media
          selftext
          removal_reason
          name
          link_flair_text
          from
          archived
          subreddit
          hidden
          locked
          author
          subreddit_id
          visited
          saved
          media_embed
          from_id
          num_reports
          id
          secure_media
          permalink
          approved_by
          title
          clicked
          banned_by
  """

  def hot_submissions(from, tag, username) do
    listing(from, tag, username, [sort: :hot], :submitted, @default_priority)
  end

  def hot_submissions(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :hot)
    listing(from, tag, username, options, :submitted, priority)
  end

  def hot_submissions(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :hot)
    listing(from, tag, username, options, :submitted, @default_priority)
  end

  def hot_submissions(from, tag, username, priority) do
    listing(from, tag, username, [sort: :hot], :submitted, priority)
  end

  @doc """
  Get a user's `new` submissions.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `subreddit`: A subreddit name or id.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing
 
  ### Fields

      after
      before
      modhash
      children:
          link_flair_css_class
          author_flair_css_class
          thumbnail
          gilded
          quarantine
          report_reasons
          selftext_html
          stickied
          domain
          created
          score
          num_comments
          secure_media_embed
          user_reports
          over_18
          suggested_sort
          url
          edited
          downs
          mod_reports
          author_flair_text
          hide_score
          created_utc
          from_kind
          likes
          is_self
          ups
          distinguished
          media
          selftext
          removal_reason
          name
          link_flair_text
          from
          archived
          subreddit
          hidden
          locked
          author
          subreddit_id
          visited
          saved
          media_embed
          from_id
          num_reports
          id
          secure_media
          permalink
          approved_by
          title
          clicked
          banned_by
  """

  def new_submissions(from, tag, username) do
    listing(from, tag, username, [sort: :new], :submitted, @default_priority)
  end

  def new_submissions(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, username, options, :submitted, priority)
  end

  def new_submissions(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, username, options, :submitted, @default_priority)
  end

  def new_submissions(from, tag, username, priority) do
    listing(from, tag, username, [sort: :hot], :submitted, priority)
  end

  @doc """
  Get a user's `top` submissions.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `subreddit`: A subreddit name or id.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `t`:      hour, day, week, month, year, all
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing
 
  ### Fields

      after
      before
      modhash
      children:
          link_flair_css_class
          author_flair_css_class
          thumbnail
          gilded
          quarantine
          report_reasons
          selftext_html
          stickied
          domain
          created
          score
          num_comments
          secure_media_embed
          user_reports
          over_18
          suggested_sort
          url
          edited
          downs
          mod_reports
          author_flair_text
          hide_score
          created_utc
          from_kind
          likes
          is_self
          ups
          distinguished
          media
          selftext
          removal_reason
          name
          link_flair_text
          from
          archived
          subreddit
          hidden
          locked
          author
          subreddit_id
          visited
          saved
          media_embed
          from_id
          num_reports
          id
          secure_media
          permalink
          approved_by
          title
          clicked
          banned_by
  """

  def top_submissions(from, tag, username) do
    listing(from, tag, username, [sort: :top], :submitted, @default_priority)
  end

  def top_submissions(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :top)
    listing(from, tag, username, options, :submitted, priority)
  end

  def top_submissions(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :top)
    listing(from, tag, username, options, :submitted, @default_priority)
  end

  def top_submissions(from, tag, username, priority) do
    listing(from, tag, username, [sort: :top], :submitted, priority)
  end

  @doc """
  Get a user's `controversial` submissions.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `subreddit`: A subreddit name or id.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `limit`:  a value between 1-100
  * `t`:      hour, day, week, month, year, all
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing
 
  ### Fields

      after
      before
      modhash
      children:
          link_flair_css_class
          author_flair_css_class
          thumbnail
          gilded
          quarantine
          report_reasons
          selftext_html
          stickied
          domain
          created
          score
          num_comments
          secure_media_embed
          user_reports
          over_18
          suggested_sort
          url
          edited
          downs
          mod_reports
          author_flair_text
          hide_score
          created_utc
          from_kind
          likes
          is_self
          ups
          distinguished
          media
          selftext
          removal_reason
          name
          link_flair_text
          from
          archived
          subreddit
          hidden
          locked
          author
          subreddit_id
          visited
          saved
          media_embed
          from_id
          num_reports
          id
          secure_media
          permalink
          approved_by
          title
          clicked
          banned_by
  """

  def controversial_submissions(from, tag, username) do
    listing(from, tag, username, [sort: :controversial], :submitted, @default_priority)
  end

  def controversial_submissions(from, tag, username, options, priority) do
    options = Keyword.put(options, :sort, :controversial)
    listing(from, tag, username, options, :submitted, priority)
  end

  def controversial_submissions(from, tag, username, options) when is_list(options) do
    options = Keyword.put(options, :sort, :controversial)
    listing(from, tag, username, options, :submitted, @default_priority)
  end

  def controversial_submissions(from, tag, username, priority) do
    listing(from, tag, username, [sort: :controversial], :submitted, priority)
  end

  @doc """
  Get a user's `new` comments on an interval.

  ### Parameters

  * `interval`: A value in milliseconds.

  ### Other

  Refer to `User.new_comments` documentation for other parameter, option and field information.
  """

  def stream_comments(from, tag, username, interval) do
    Scheduler.schedule({@user, :new_comments}, [from, tag, username, [], @default_priority], interval)
  end

  def stream_comments(from, tag, username, options, interval) when is_list(options) do
    Scheduler.schedule({@user, :new_comments}, [from, tag, username, options, @default_priority], interval)
  end

  def stream_comments(from, tag, username, priority, interval) do
    Scheduler.schedule({@user, :new_comments}, [from, tag, username, [] , priority], interval)
  end

  def stream_comments(from, tag, username, options, priority, interval) do
    Scheduler.schedule({@user, :new_comments}, [from, tag, username, options, priority], interval)
  end

  @doc """
  Get a user's `new` submissions on an interval.

  ### Parameters

  * `interval`: A value in milliseconds.

  ### Other

  Refer to `User.submissions` documentation for other parameter, option and field information.
  """

  def stream_submissions(from, tag, username, interval) do
    Scheduler.schedule({@user, :submissions}, [from, tag, username, [], @default_priority], interval)
  end

  def stream_submissions(from, tag, username, options, interval) when is_list(options) do
    Scheduler.schedule({@user, :submissions}, [from, tag, username, options, @default_priority], interval)
  end

  def stream_submissions(from, tag, username, priority, interval) do
    Scheduler.schedule({@user, :submissions}, [from, tag, username, [] , priority], interval)
  end

  def stream_submissions(from, tag, username, options, priority, interval) do
    Scheduler.schedule({@user, :submissions}, [from, tag, username, options, priority], interval)
  end

  @doc """
  Paginate a user's `hot` comments. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.hot_comments` documentation for other parameter, option and field information.

  """

  def paginate_hot_comments(from, tag, username) do
    Paginator.paginate({@user, :hot_comments}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_hot_comments(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :hot_comments}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_hot_comments(from, tag, username, priority) do
    Paginator.paginate({@user, :hot_comments}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_hot_comments(from, tag, username, options, priority) do
    Paginator.paginate({@user, :hot_comments}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `new` comments. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.new_comments` documentation for other parameter, option and field information.
  """

  def paginate_new_comments(from, tag, username) do
    Paginator.paginate({@user, :new_comments}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_new_comments(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :new_comments}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_new_comments(from, tag, username, priority) do
    Paginator.paginate({@user, :new_comments}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_new_comments(from, tag, username, options, priority) do
    Paginator.paginate({@user, :new_comments}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `top` comments. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.top_comments` documentation for other parameter, option and field information.
  """

  def paginate_top_comments(from, tag, username) do
    Paginator.paginate({@user, :top_comments}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_top_comments(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :top_comments}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_top_comments(from, tag, username, priority) do
    Paginator.paginate({@user, :top_comments}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_top_comments(from, tag, username, options, priority) do
    Paginator.paginate({@user, :top_comments}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `controversial` comments. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.controversial_comments` documentation for other parameter, option and field information.
  """

  def paginate_controversial_comments(from, tag, username) do
    Paginator.paginate({@user, :controversial_comments}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_controversial_comments(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :controversial_comments}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_controversial_comments(from, tag, username, priority) do
    Paginator.paginate({@user, :controversial_comments}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_controversial_comments(from, tag, username, options, priority) do
    Paginator.paginate({@user, :controversial_comments}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `hot` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.hot_submissions` documentation for other parameter, option and field information.
  """

  def paginate_hot_submissions(from, tag, username) do
    Paginator.paginate({@user, :hot_submissions}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_hot_submissions(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :hot_submissions}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_hot_submissions(from, tag, username, priority) do
    Paginator.paginate({@user, :hot_submissions}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_hot_submissions(from, tag, username, options, priority) do
    Paginator.paginate({@user, :hot_submissions}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `new` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.new_submissions` documentation for other parameter, option and field information.
  """

  def paginate_new_submissions(from, tag, username) do
    Paginator.paginate({@user, :new_submissions}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_new_submissions(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :new_submissions}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_new_submissions(from, tag, username, priority) do
    Paginator.paginate({@user, :new_submissions}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_new_submissions(from, tag, username, options, priority) do
    Paginator.paginate({@user, :new_submissions}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `top` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.top_submissions` documentation for other parameter, option and field information.
  """

  def paginate_top_submissions(from, tag, username) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_top_submissions(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_top_submissions(from, tag, username, priority) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_top_submissions(from, tag, username, options, priority) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, put_limit(options), priority])
  end

  @doc """
  Paginate a user's `controversial` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `User.contorversial_submissions` documentation for other parameter, option and field information.
  """

  def paginate_controversial_submissions(from, tag, username) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, [limit: 1000], @default_priority])
  end

  def paginate_controversial_submissions(from, tag, username, options) when is_list(options) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, put_limit(options), @default_priority])
  end

  def paginate_controversial_submissions(from, tag, username, priority) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, [limit: 1000], priority])
  end

  def paginate_controversial_submissions(from, tag, username, options, priority) do
    Paginator.paginate({@user, :top_submissions}, [from, tag, username, put_limit(options), priority])
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

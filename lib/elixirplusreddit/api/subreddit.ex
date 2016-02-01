defmodule ElixirPlusReddit.API.Subreddit do

  @moduledoc """
  An interface for getting subreddit information.
  """

  alias ElixirPlusReddit.RequestQueue
  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.Paginator
  alias ElixirPlusReddit.Scheduler

  @subreddit       __MODULE__
  @subreddit_base  "https://oauth.reddit.com/r"
  @default_priority 0

  defdelegate submit_url(from,
                         tag,
                         subreddit,
                         title,
                         url,
                         send_replies?), to: ElixirPlusReddit.API.Post
  
  defdelegate submit_url(from,
                         tag,
                         subreddit,
                         title,
                         url,
                         send_replies?,
                         priority), to: ElixirPlusReddit.API.Post

  defdelegate submit_text(from,
                          tag,
                          subreddit,
                          title,
                          text,
                          send_replies?), to: ElixirPlusReddit.API.Post

  defdelegate submit_text(from,
                          tag,
                          subreddit,
                          title,
                          text,
                          send_replies?,
                          priority), to: ElixirPlusReddit.API.Post
  
  @doc """
  Get a subreddit's `hot` submissions.

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

  @doc """
  Get a subreddit's `new` submissions.

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

  @doc """
  Get a subreddit's `rising` submissions.

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

  @doc """
  Get a subreddit's `controversial` submissions.

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

  @doc """
  Get a subreddit's `top` submissions.

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

   @doc """
  Get a subreddit's `gilded` submissions.

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

  @doc """
  Get a subreddit's most recent comments.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `subreddit:` A subreddit name or id.
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

  @doc """
  Get a subreddit's new submissions on an interval.

  ### Parameters

  * `interval`: A value in milliseconds.

  ### Other

  Refer to `Subreddit.new_submissions` documentation for other parameter, option and field information.
  """

  def stream_submissions(from, tag, subreddit, interval) do
    Scheduler.schedule({@subreddit, :new}, [from, tag, subreddit, [], @default_priority], interval)
  end

  def stream_submissions(from, tag, subreddit, options, interval) when is_list(options) do
    Scheduler.schedule({@subreddit, :new}, [from, tag, subreddit, options, @default_priority], interval)
  end

  def stream_submissions(from, tag, subreddit, priority, interval) do
    Scheduler.schedule({@subreddit, :new}, [from, tag, subreddit, [] , priority], interval)
  end

  def stream_submissions(from, tag, subreddit, options, priority, interval) do
    Scheduler.schedule({@subreddit, :new}, [from, tag, subreddit, options, priority], interval)
  end

  @doc """
  Paginate a subreddit's `hot` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.hot_submissions` documentation for other parameter, option and field information.
  """

  def paginate_hot(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :hot}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_hot(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :hot}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_hot(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :hot}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_hot(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :hot}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Paginate a subreddit's `new` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.new_submissions` documentation for other parameter, option and field information.
  """

  def paginate_new(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :new}, [subreddit, [from, tag, limit: 1000], @default_priority])
  end

  def paginate_new(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :new}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_new(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :new}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_new(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :new}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Paginate a subreddit's `rising` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.rising_submissions` documentation for other parameter, option and field information.
  """

  def paginate_rising(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :rising}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_rising(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :rising}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_rising(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :rising}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_rising(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :rising}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Paginate a subreddit's `controversial` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.controversial_submissions` documentation for other parameter, option and field information.
  """

  def paginate_controversial(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :controversial}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_controversial(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :controversial}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_controversial(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :controversial}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_controversial(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :controversial}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Paginate a subreddit's `top` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.top_submissions` documentation for other parameter, option and field information.
  """

  def paginate_top(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :top}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_top(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :top}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_top(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :top}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_top(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :top}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Paginate a subreddit's `gilded` submissions. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.gilded_submissions` documentation for other parameter, option and field information.
  """

  def paginate_gilded(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :gilded}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_gilded(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :gilded}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_gilded(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :gilded}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_gilded(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :gilded}, [from, tag, subreddit, put_limit(options), priority])
  end

  @doc """
  Get a subreddit's new comments on an interval.

  ### Parameters

  * `interval`: A value in milliseconds.

  ### Other

  Refer to `Subreddit.new_submissions` documentation for other parameter, option and field information.
  """


  def stream_comments(from, tag, subreddit, interval) do
    Scheduler.schedule({@subreddit, :comments}, [from, tag, subreddit, [], @default_priority], interval)
  end

  def stream_comments(from, tag, subreddit, options, interval) when is_list(options) do
    Scheduler.schedule({@subreddit, :comments}, [from, tag, subreddit, options, @default_priority], interval)
  end

  def stream_comments(from, tag, subreddit, priority, interval) do
    Scheduler.schedule({@subreddit, :comments}, [from, tag, subreddit, [] , priority], interval)
  end

  def stream_comments(from, tag, subreddit, options, priority, interval) do
    Scheduler.schedule({@subreddit, :comments}, [from, tag, subreddit, options, priority], interval)
  end

  @doc """
  Paginate a subreddit's comments. Pagination does NOT return the `before` and `after` fields, only the 
  `children` field. When pagination is complete a message is sent to `from` in the form of {`tag`, `:complete`}
  and the pagination process is gracefully terminated.

  ### Options

  * `limit`: a value between 1-1000

  ### Other

  Refer to `Subreddit.comments` documentation for other parameter, option and field information.
  """

  def paginate_comments(from, tag, subreddit) do
    Paginator.paginate({@subreddit, :comments}, [from, tag, subreddit, [limit: 1000], @default_priority])
  end

  def paginate_comments(from, tag, subreddit, options) when is_list(options) do
    Paginator.paginate({@subreddit, :comments}, [from, tag, subreddit, put_limit(options), @default_priority])
  end

  def paginate_comments(from, tag, subreddit, priority) do
    Paginator.paginate({@subreddit, :comments}, [from, tag, subreddit, [limit: 1000], priority])
  end

  def paginate_comments(from, tag, subreddit, options, priority) do
    Paginator.paginate({@subreddit, :comments}, [from, tag, subreddit, put_limit(options), priority])
  end

  defp put_limit(options) do
    case Keyword.has_key?(options, :limit) do
      true  -> options
      false -> Keyword.put(options, :limit, 1000)
    end
  end

  defp listing(from, tag, subreddit, options, endpoint, priority) do
    url = "#{@subreddit_base}/#{subreddit}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestQueue.enqueue_request(request_data)
  end

end

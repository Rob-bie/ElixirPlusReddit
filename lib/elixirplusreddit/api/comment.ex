defmodule ElixirPlusReddit.API.Comment do
  @moduledoc """
  An interface for getting comment information.
  """

  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.RequestQueue
  alias ElixirPlusReddit.Paginator
  alias ElixirPlusReddit.Scheduler

  @comment __MODULE__
  @comment_base "https://oauth.reddit.com/comments"
  @default_priority 0

  @doc """
  Get an article's `new` comments.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `article_id:` An article id.
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

  def new_comments(from, tag, article_id) do
    listing(from, tag, article_id, [sort: :new], @default_priority)
  end

  def new_comments(from, tag, article_id, options, priority) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, article_id, options, priority)
  end

  def new_comments(from, tag, article_id, options) when is_list(options) do
    options = Keyword.put(options, :sort, :new)
    listing(from, tag, article_id, options, @default_priority)
  end

  def new_comments(from, tag, article_id, priority) do
    listing(from, tag, article_id, [sort: :new], priority)
  end

  defp listing(from, tag, article_id, options, priority) do
    url = "#{@comment_base}/#{article_id}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestQueue.enqueue_request(request_data)
  end
end

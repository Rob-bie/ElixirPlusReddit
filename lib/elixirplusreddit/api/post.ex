defmodule ElixirPlusReddit.API.Post do

  @moduledoc """
  An interface for various post actions.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder

  @comment_endpoint "https://oauth.reddit.com/api/comment"
  @default_priority  0

  @doc """
  Reply to a comment or submission.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `id`:        A comma separated list of message ids.
  * `text`:      The reply body.
  * `priority`:  The request's priority. (Optional)

  ### Fields
      distinguished
      saved
      replies
      link_id
      report_reasons
      likes
      banned_by
      subreddit_id
      body_html
      archived
      gilded
      score_hidden
      body
      created_utc
      ups
      stickied
      edited
      num_reports
      mod_reports
      approved_by
      errors
      user_reports
      name
      controversiality
      parent_id
      removal_reason
      author_flair_text
      created
      id
      downs
      author
      subreddit
      author_flair_css_class
      score
  """

  def reply(from, tag, id, text, priority \\ @default_priority) do
    query = [api_type: :json, text: text, thing_id: id]
    request_data = RequestBuilder.format_post(from, tag, @comment_endpoint, query, :reply, priority)
    RequestServer.enqueue_request(request_data)
  end
  
end

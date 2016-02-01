defmodule ElixirPlusReddit.API.Post do

  @moduledoc """
  An interface for various post actions. These functions are generally
  delegated to.
  """

  alias ElixirPlusReddit.RequestQueue
  alias ElixirPlusReddit.RequestBuilder

  @comment_endpoint "https://oauth.reddit.com/api/comment"
  @submit_endpoint "https://oauth.reddit.com/api/submit"
  @compose_endpoint "https://oauth.reddit.com/api/compose"
  @default_priority  0

  @doc """
  Reply to a comment, submission or private message.

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
      archived?
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
    RequestQueue.enqueue_request(request_data)
  end


  @doc """
  Submit a url submission.

  ### Parameters

  * `from`:          The pid or name of the requester.
  * `tag`:           Anything.
  * `subreddit`:     The name of a subreddit.
  * `title`:         The submission's title.
  * `url`:           The submission's url.
  * `send_replies?`: Send submission replies to inbox. (true, false)
  * `priority`:      The request's priority. (Optional)

  ### Fields

      id
      name
      url
      errors
  """

  def submit_url(from, tag, subreddit, title, url, send_replies?, priority \\ @default_priority) do
    query = [
      api_type: :json,
      sr: subreddit,
      resubmit: true,
      kind: :link,
      sendreplies: send_replies?,
      title: title,
      url: url
    ]
    request_data = RequestBuilder.format_post(from, tag, @submit_endpoint, query, :submission, priority)
    RequestQueue.enqueue_request(request_data)
  end

  @doc """
  Submit a text submission.

  ### Parameters

  * `from`:          The pid or name of the requester.
  * `tag`:           Anything.
  * `subreddit`:     The name of a subreddit.
  * `title`:         The submission's title.
  * `text`:          The submission's text.
  * `send_replies?`: Send submission replies to inbox. (true, false)
  * `priority`:      The request's priority. (Optional)

  ### Fields

      id
      name
      url
      errors
  """

  def submit_text(from, tag, subreddit, title, text, send_replies?, priority \\ @default_priority) do
    query = [
      api_type: :json,
      sr: subreddit,
      resubmit: true,
      kind: :self,
      sendreplies: send_replies?,
      title: title,
      text: text
    ]
    request_data = RequestBuilder.format_post(from, tag, @submit_endpoint, query, :submission, priority)
    RequestQueue.enqueue_request(request_data)
  end

  @doc """
  Start a new private conversation.

  ### Parameters

  * `from`:     The pid or name of the requester.
  * `tag`:      Anything.
  * `to`:       The user receiving the message.
  * `subject`:  The message's subject.
  * `text`:     The message's text.
  * `priority`: The request's priority. (Optional)

  ### Fields
      errors
  """

  def compose(from, tag, to, subject, text, priority \\ @default_priority) do
    query = [api_type: :json, to: to, subject: subject, text: text]
    request_data = RequestBuilder.format_post(from, tag, @compose_endpoint, query, :compose, priority)
    RequestQueue.enqueue_request(request_data)
  end
  
end

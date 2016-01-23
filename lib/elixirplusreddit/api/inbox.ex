defmodule ElixirPlusReddit.API.Inbox do

  @moduledoc """
  An interface for getting inbox related information and performing
  inbox related actions.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder
  alias ElixirPlusReddit.Paginator

  @message_base       "https://oauth.reddit.com/message"
  @mark_read_endpoint "https://oauth.reddit.com/api/read_message"
  @default_priority    0

  @doc """
  Mark a message or list a messages as read.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `id`:        A comma separated list of message ids.
  * `priority`:  The request's priority. (Optional)

  ### Fields
      empty map (%{})
  """

  def mark_read(from, tag, id, priority \\ @default_priority) do
    request_data = RequestBuilder.format_post(from, tag, @mark_read_endpoint, [id: id], :ok, priority)
    RequestServer.enqueue_request(request_data)
  end

  @doc """
  Get the authenticated user's inbox.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `mark`:   true or false
  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

      after
      before
      modhash
      children:
          author
          body
          body_html
          context
          created
          created_utc
          dest
          distinguished
          first_message
          first_message_name
          id
          likes
          link_title
          name
          new
          parent_id
          replies
          subject
          subreddit
  """

  def inbox(from, tag) do
    listing(from, tag, [], :inbox, @default_priority)
  end

  def inbox(from, tag, options) when is_list(options) do
    listing(from, tag, options, :inbox, @default_priority)
  end

  def inbox(from, tag, priority) do
    listing(from, tag, [], :inbox, priority)
  end

  @doc """
  Get the authenticated user's unread inbox.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `mark`:   true or false
  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

  after
  before
  modhash
  children:
      author
      body
      body_html
      context
      created
      created_utc
      dest
      distinguished
      first_message
      first_message_name
      id
      likes
      link_title
      name
      new
      parent_id
      replies
      subject
      subreddit
  """

  def unread(from, tag) do
    listing(from, tag, [], :unread, @default_priority)
  end

  def unread(from, tag, options) when is_list(options) do
    listing(from, tag, options, :unread, @default_priority)
  end

  def unread(from, tag, priority) do
    listing(from, tag, [], :unread, priority)
  end

  def unread(from, tag, options, priority) do
    listing(from, tag, options, :unread, priority)
  end

  @doc """
  Get the authenticated user's sent inbox.

  ### Parameters

  * `from`:      The pid or name of the requester.
  * `tag`:       Anything.
  * `options`:   The query. (Optional)
  * `priority`:  The request's priority. (Optional)

  ### Options

  * `mark`:   true or false
  * `limit`:  a value between 1-100
  * `after`:  a fullname of a thing
  * `before`: a fullname of a thing

  ### Fields

  after
  before
  modhash
  children:
      author
      body
      body_html
      context
      created
      created_utc
      dest
      distinguished
      first_message
      first_message_name
      id
      likes
      link_title
      name
      new
      parent_id
      replies
      subject
      subreddit
  """

  def sent(from, tag) do
    listing(from, tag, [], :sent, @default_priority)
  end

  def sent(from, tag, options) when is_list(options) do
    listing(from, tag, options, :sent, @default_priority)
  end

  def sent(from, tag, priority) do
    listing(from, tag, [], :sent, priority)
  end

  defp listing(from, tag, options, endpoint, priority) do
    url = "#{@message_base}/#{endpoint}"
    request_data = RequestBuilder.format_get(from, tag, url, options, :listing, priority)
    RequestServer.enqueue_request(request_data)
  end

end

defmodule ElixirPlusReddit.API.Post do

  @moduledoc """
  An interface for various post actions.
  """

  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.RequestBuilder

  @comment_endpoint "https://oauth.reddit.com/api/comment"

  def comment(from, tag, id, text, priority \\ 0) do
    query = [api_type: :json, text: text, thing_id: id]
    request_data = RequestBuilder.format_post(from, tag, @comment_endpoint, query, :ok, priority)
    RequestServer.enqueue_request(request_data)
  end
  
end

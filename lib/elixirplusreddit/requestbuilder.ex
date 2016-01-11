defmodule ElixirPlusReddit.RequestBuilder do

  @moduledoc """
  A utility module for formatting request data.
  """

  def format_get(from, tag, url, parse_strategy, priority) do
    %{
      method: :get,
      from: from,
      tag: tag,
      url: url,
      parse_strategy: parse_strategy,
      priority: priority
    }
  end


  def format_get(from, tag, url, query, parse_strategy, priority) do
    %{
      method: :get,
      from: from,
      tag: tag,
      url: url,
      query: query,
      parse_strategy: parse_strategy,
      priority: priority
    }
  end

  def format_post(from, tag, url, query, parse_strategy, priority) do
    %{
      method: :post,
      from: from,
      tag: tag,
      url: url,
      query: query,
      parse_strategy: parse_strategy,
      priority: priority
    }
  end

end

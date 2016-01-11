defmodule ElixirPlusReddit.RequestServer do
  use GenServer

  @moduledoc """
  Distributes responses, handles rate limiting and implements priority based
  request issuing. As a consequence of requests being statically rate limited
  you must provide a tag and pid with each request. This enables a way to
  deliver responses when they are available and a convenient way to pattern match
  on them. Requests are also accompanied by a priority, priorties create an
  easy way to ensure that important requests are issued before others of lesser
  importance.
  """

  alias ElixirPlusReddit.Request
  alias ElixirPlusReddit.PQueue

  @requestserver    __MODULE__
  @request_interval 1000

  @doc """
  Start the request server.
  """

  def start_link do
    GenServer.start_link(@requestserver, [], name: @requestserver)
  end

  def enqueue_request(request_data) do
    GenServer.cast(@requestserver, {:enqueue_request, request_data})
  end

  def init(_) do
    schedule_request
    {:ok, PQueue.new}
  end

  def handle_cast({:enqueue_request, %{priority: p} = request_data}, request_queue) do
    {:noreply, PQueue.enqueue(request_queue, request_data, p)}
  end

  def handle_info(:next_request, request_queue) do
    case PQueue.is_empty?(request_queue) do
      true  ->
        schedule_request
        {:noreply, request_queue}
      false ->
        {{:value, request_data}, request_queue} = PQueue.dequeue(request_queue)
        %{from: from, tag: tag} = request_data
        resp = issue_request(request_data)
        schedule_request
        send(from, {tag, resp})
        {:noreply, request_queue}
    end
  end

  defp issue_request(%{method: :post} = request_data) do
    %{url: url, query: query, parse_strategy: strategy} = request_data
    Request.request(:post, url, query, strategy)
  end

  defp issue_request(%{method: :get, query: query} = request_data) do
    %{url: url, parse_strategy: strategy} = request_data
    Request.request(:get, url, query, strategy)
  end

  defp issue_request(%{method: :get} = request_data) do
    %{url: url, parse_strategy: strategy} = request_data
    Request.request(:get, url, strategy)
  end

  defp schedule_request do
    Process.send_after(@requestserver, :next_request, @request_interval)
  end

end

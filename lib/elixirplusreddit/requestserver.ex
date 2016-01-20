defmodule ElixirPlusReddit.RequestServer do
  use GenServer

  @moduledoc """
  Distributes responses, handles rate limiting and implements priority based
  request issuing.

  ### Details

  A consequence of requests being statically rate limited is that
  you must provide a tag and pid with each request. This enables a way to
  deliver responses when they are available and a convenient way to pattern match
  on them. Requests are also accompanied by a priority, priorties create an
  easy way to ensure that important requests are issued before others of lesser
  importance.
  """

  alias ElixirPlusReddit.Request
  alias ElixirPlusReddit.PQueue

  @requestserver       __MODULE__
  @request_interval    1000
  @no_request_interval 500

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
    schedule_request(@no_request_interval)
    {:ok, PQueue.new}
  end

  def handle_cast({:enqueue_request, %{priority: p} = request_data}, request_queue) do
    {:noreply, PQueue.enqueue(request_queue, request_data, p)}
  end

  def handle_info(:next_request, request_queue) do
    case PQueue.is_empty?(request_queue) do
      true  ->
        schedule_request(@no_request_interval)
        {:noreply, request_queue}
      false ->
        {{:value, request_data}, request_queue} = PQueue.dequeue(request_queue)
        %{from: from, tag: tag} = request_data
        resp = issue_request(request_data)
        send_response(from, {tag, resp})
        schedule_request(@request_interval)
        {:noreply, request_queue}
    end
  end

  defp send_response(from, {tag, resp}) do
    send(from, {tag, resp})
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

  defp schedule_request(interval) do
    Process.send_after(@requestserver, :next_request, interval)
  end

end

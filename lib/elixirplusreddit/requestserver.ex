defmodule ElixirPlusReddit.RequestServer do
  use GenServer

  @moduledoc """
  Rate limits requests and distributes responses.
  """

  alias ElixirPlusReddit.Request
  alias ElixirPlusReddit.Parser
  alias ElixirPlusReddit.RequestQueue

  @requestserver       __MODULE__
  @request_interval    1000
  @no_request_interval 500

  def start_link do
    GenServer.start_link(@requestserver, [], name: @requestserver)
  end

  def init(_) do
    schedule_request(@no_request_interval)
    {:ok, :no_state}
  end

  def handle_info(:next_request, :no_state) do
    case RequestQueue.is_empty? do
      true  ->
        schedule_request(@no_request_interval)
        {:noreply, :no_state}
      false ->
        %{from: from, tag: tag} = request_data = RequestQueue.peek_request
        resp = retry_until_success(request_data)
        RequestQueue.dequeue_request
        send_response(from, {tag, resp})
        schedule_request(@request_interval)
        {:noreply, :no_state}
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

  defp retry_until_success(request_data) do
    {resp, parse_strategy} = issue_request(request_data)
    case resp.status_code do
      503 -> retry_until_success(request_data)
      _   -> resp |> Parser.parse(parse_strategy)
    end
  end

  defp schedule_request(interval) do
    Process.send_after(@requestserver, :next_request, interval)
  end

end

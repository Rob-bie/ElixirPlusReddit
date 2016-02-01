defmodule ElixirPlusReddit.RequestQueue do

  @moduledoc """
  A request queue built on top of an Agent. Handles distributing
  requests to the request server. The queue is externalized from the server
  to avoid loss of important state and for handling timeouts.
  """

  @request_queue __MODULE__

  alias ElixirPlusReddit.PQueue

  def start_link do
    Agent.start_link(fn -> PQueue.new end, name: @request_queue)
  end

  def enqueue_request(%{priority: p} = request_data) do
    Agent.update(@request_queue, fn(request_queue) ->
      PQueue.enqueue(request_queue, request_data, p)
    end)
  end

  def peek_request do
    Agent.get(@request_queue, fn(request_queue) ->
      {{:value, request}, _request_queue} = PQueue.dequeue(request_queue)
      request
    end)
  end

  def dequeue_request do
    Agent.update(@request_queue, fn(request_queue) ->
      {{:value, _request}, request_queue} = PQueue.dequeue(request_queue)
      request_queue
    end)
  end

  def is_empty? do
    Agent.get(@request_queue, fn(request_queue) ->
      PQueue.is_empty?(request_queue)
    end)
  end

end

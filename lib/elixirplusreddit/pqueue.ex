defmodule ElixirPlusReddit.PQueue do

  @moduledoc """
  A tiny wrapper around okeuday's pqueue library.
  """

  @doc """
  Create a new pqueue.
  """

  def new do
    :pqueue.new
  end

  @doc """
  Insert a request into a pqueue.
  """

  def enqueue(pqueue, request, priority) do
    :pqueue.in(request, priority, pqueue)
  end

  @doc """
  Return the next request in the pqueue.
  """

  def dequeue(pqueue) do
    :pqueue.out(pqueue)
  end

  @doc """
  Return if the pqueue is empty.
  """

  def is_empty?(pqueue) do
    :pqueue.is_empty(pqueue)
  end

end

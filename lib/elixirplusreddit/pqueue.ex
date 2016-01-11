defmodule ElixirPlusReddit.PQueue do

  def enqueue(pqueue, request, priority) do
    :pqueue.in(request, priority, pqueue)
  end

  def dequeue(pqueue) do
    :pqueue.out(pqueue)
  end

  def is_empty?(pqueue) do
    :pqueue.is_empty(pqueue)
  end

end

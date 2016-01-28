defmodule ElixirPlusReddit.Scheduler do
  use GenServer

  @moduledoc """
  A generic implementation for scheduling API calls on an interval.
  """

  @scheduler __MODULE__

  def schedule({module, function}, arguments, interval) do
    start_link({module, function}, arguments, interval)
  end

  def schedule({module, function}, interval) do
    start_link({module, function}, [], interval)
  end

  def start_link({module, function}, arguments, interval) do
    config = [
      module: module,
      function: function,
      arguments: arguments,
      interval: interval
    ]

    GenServer.start_link(@scheduler, config, [])
  end

  def init(config) do
    process_request(config)
    schedule_request(config[:interval])
    {:ok, config}
  end

  def handle_info(:next_request, config) do
    process_request(config)
    schedule_request(config[:interval])
    {:noreply, config}
  end

  defp process_request([module: m, function: x, arguments: a, interval: _]) do
    apply(m, x, a)
  end

  defp schedule_request(interval) do
    Process.send_after(self, :next_request, interval)
  end

end

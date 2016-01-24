defmodule ElixirPlusReddit.Scheduler do
  use GenServer

  @moduledoc """
  A generic implementation for scheduling API calls on an interval.
  """

  @scheduler __MODULE__

  def schedule(from, tag, {module, function}, arguments, interval) do
    start_link(from, tag, {module, function}, arguments, interval)
  end

  def schedule(from, tag, {module, function}, interval) do
    start_link(from, tag, {module, function}, [], interval)
  end

  def start_link(from, tag, {module, function}, arguments, interval) do
    config = [from: from,
              tag: tag,
              module: module,
              function: function,
              arguments: arguments,
              interval: interval]

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

  defp process_request([from: f, tag: t, module: m, function: x, arguments: a, interval: _]) do
    arguments = a
    |> Enum.reduce([t, f], fn(arg, acc) -> [arg|acc] end)
    |> Enum.reverse

    apply(m, x, arguments)
  end

  defp schedule_request(interval) do
    Process.send_after(self, :next_request, interval)
  end

end

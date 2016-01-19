defmodule ElixirPlusReddit.Paginator do
  use GenServer

  @moduledoc """
  An interface for paginating through listings.
  """

  @paginator __MODULE__

  def paginate(from, tag, {module, function}, arguments, interval) do
    start_link(from, tag, {module, function}, arguments, interval)
  end

  def start_link(from, tag, {module, function}, arguments, interval) do
    config = [from: from,
              tag: tag,
              module: module,
              function: function,
              arguments: arguments,
              interval: interval]

    GenServer.start_link(@paginator, config, [])
  end

  def init(config) do
    process_request(config, self)
    {:ok, config}
  end

  def handle_info({tag, resp}, config) do
    after_id = resp.after
    send(config[:from], {tag, resp})
    case after_id do
      nil ->
        send(self, :stop)
        {:noreply, config}
      id  ->
        new_config = update_config(config, id)
        process_request(new_config, self)
        {:noreply, new_config}
    end
  end

  def handle_info(:stop, config) do
    {:stop, :normal, config}
  end

  def terminate(:normal, _config) do
    :ok
  end

  defp process_request([from: _, tag: t, module: m, function: x, arguments: a, interval: _], server) do
    arguments = a
    |> Enum.reduce([t, server], fn(arg, acc) -> [arg|acc] end)
    |> Enum.reverse

    apply(m, x, arguments)
  end

  defp update_config(config, after_id) do
    Keyword.update!(config, :arguments, fn(arguments) ->
      Enum.map(arguments, fn(arg) ->
        case is_list(arg) do
          true  -> Keyword.put(arg, :after, after_id)
          false -> arg
        end
      end)
    end)
  end

end

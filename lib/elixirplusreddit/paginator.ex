defmodule ElixirPlusReddit.Paginator do
  use GenServer

  @moduledoc """
  A generic interface for paginating through listings.
  """

  @paginator __MODULE__

  def paginate(from, tag, {module, function}, arguments) do
    start_link(from, tag, {module, function}, arguments)
  end

  def start_link(from, tag, {module, function}, arguments) do
    config = [from: from,
              tag: tag,
              module: module,
              function: function,
              arguments: arguments]

    GenServer.start_link(@paginator, config, [])
  end

  def init(config) do
    process_request(config, self)
    {:ok, config}
  end

  def handle_info({tag, resp}, config) do
    send(config[:from], {tag, resp})
    case resp.after do
      nil ->
        send(config[:from], {tag, :complete})
        send(self, :stop)
        {:noreply, config}
      id  ->
        new_config = update_limit(config)
        cond do
          get_limit(new_config) <= 0 ->
            send(config[:from], {tag, :complete})
            send(self, :stop)
            {:noreply, new_config}
          true ->
            new_config = update_id(new_config, id)
            process_request(new_config, self)
            {:noreply, new_config}
        end
    end
  end

  def handle_info(:stop, config) do
    {:stop, :normal, config}
  end

  def terminate(:normal, _config) do
    :ok
  end

  defp process_request([from: _, tag: t, module: m, function: x, arguments: a], server) do
    arguments = a
    |> Enum.reduce([t, server], fn(arg, acc) -> [arg|acc] end)
    |> Enum.reverse

    apply(m, x, arguments)
  end

  defp get_limit(config) do
    Enum.reduce(config[:arguments], nil, fn(arg, acc) ->
      case is_list(arg) do
        true  -> arg[:limit]
        false -> acc
      end
    end)
  end

  defp update_limit(config) do
    Keyword.update!(config, :arguments, fn(arguments) ->
      Enum.map(arguments, fn(arg) ->
        case is_list(arg) do
          true  -> Keyword.update!(arg, :limit, fn(limit) -> limit - 100 end)
          false -> arg
        end
      end)
    end)
  end

  defp update_id(config, after_id) do
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

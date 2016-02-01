defmodule ElixirPlusReddit do
  use Application

  alias ElixirPlusReddit.RequestQueue
  alias ElixirPlusReddit.RequestServer
  alias ElixirPlusReddit.TokenServer

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RequestQueue, []),
      worker(RequestServer, []),
      worker(TokenServer, [])
    ]

    opts = [strategy: :one_for_one, name: ElixirPlusReddit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

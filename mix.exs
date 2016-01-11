defmodule ElixirPlusReddit.Mixfile do
  use Mix.Project

  def project do
    [app: :elixirplusreddit,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {ElixirPlusReddit, []}]
  end

  defp deps do
    [{:pqueue, github: "okeuday/pqueue"}]
  end

end

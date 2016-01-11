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
    [applications: [:logger, :httpotion],
     mod: {ElixirPlusReddit, []}]
  end

  defp deps do
    [
     {:pqueue, github: "okeuday/pqueue"},
     {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
     {:httpotion, "~> 2.1.0"},
     {:poison, "~> 1.5"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

end

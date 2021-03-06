defmodule Aurum.MixProject do
  use Mix.Project

  def project do
    [
      app: :aurum,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, path: "/Users/alex/prog/httpotion"},
      #      {:httpotion, "~> 3.1.2"},
      {:poison, "~> 4.0.1"}
    ]
  end
end

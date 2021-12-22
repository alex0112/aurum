defmodule Aurum.MixProject do
  use Mix.Project

  def project do
    [
      app: :aurum,
      version: "0.2.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      licenses: ["GPLv3"],
      links: %{github: "https://github.com/alex0112/aurum"},
      description: """
      An Elixir Client for the Coinbase API (V2)
      """
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
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:poison, "~> 5.0"},
      {:ex_doc, "~> 0.24"},
    ]
  end
end

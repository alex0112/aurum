defmodule Aurum.MixProject do
  use Mix.Project

  def project do
    [
      app: :aurum,
      version: "0.1.0",
      elixir: "~> 1.12",
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
    {:tesla, "~> 1.4"},

    # optional, but recommended adapter
    {:hackney, "~> 1.17"},

    # optional, required by JSON middleware
    {:jason, ">= 1.0.0"}
    ]
  end
end

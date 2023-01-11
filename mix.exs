defmodule Lucideicons.MixProject do
  use Mix.Project

  def project do
    [
      app: :lucide_icons,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_view, "~> 0.17", optional: true},
    ]
  end
end

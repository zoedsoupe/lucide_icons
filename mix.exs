defmodule Lucideicons.MixProject do
  use Mix.Project

  @version "1.1.2"
  @github_url "https://github.com/zoedsoupe/lucide_icons"

  def project do
    [
      app: :lucide_icons,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: @github_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 1.0.0"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Lucideicons",
      source_ref: "v#{@version}",
      source_url: @github_url,
      groups_for_modules: [LiveView: ~r/Lucideicons.LiveView/],
      nest_modules_by_prefix: [Lucideicons.LiveView],
      extras: ["README.md"]
    ]
  end

  defp description do
    """
    This package adds a convenient way of using Lucide
    with your Phoenix and Phoenix LiveView applications.

    Lucide is "An open source icon library for displaying
    icons and symbols in digital and non-digital projects.
    It consists of 850+ Vector (svg) files", and is a fork
    of Feather Icons.
    """
  end

  defp package do
    %{
      files: ~w(lib priv .formatter.exs mix.exs README.md LICENSE),
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => @github_url}
    }
  end
end

# Lucideicons

![CI](https://github.com/zoedsoupe/lucide_icons/actions/workflows/ci.yml/badge.svg)

This package adds a convenient way of using [Lucide](https://lucide.dev/) with your Phoenix and Surface applications.

Lucide is "An open source icon library for displaying icons and symbols in digital and non-digital projects. It consists of 850+ Vector (svg) files", and is a fork of Feather Icons.

You can find the original docs [here](https://lucide.dev/docs) and repo [here](https://github.com/lucide-icons/lucide).

## Installation

Add `lucide_icons` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lucide_icons, "~> 0.1.0"}
  ]
end
```

Then run `mix deps.get`.

## Usage

#### With Heex

```elixir
<Lucideicons.icon name="academic-cap" type="outline" class="h-4 w-4" />
```

#### With Surface

```elixir
<Lucideicons.Surface.Icon name="academic-cap" type="outline" class="h-4 w-4" />
```

## Config

Defaults can be set in the `Lucideicons` application configuration.

```elixir
config :lucide_icons, type: "outline"
```

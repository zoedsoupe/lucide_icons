# Lucideicons

![CI](https://github.com/zoedsoupe/lucide_icons/actions/workflows/ci.yml/badge.svg)

This package adds a convenient way of using [Lucide](https://lucide.dev/) with your Phoenix.LiveView applications.

Lucide is "An open source icon library for displaying icons and symbols in digital and non-digital projects. It consists of 850+ Vector (svg) files", and is a fork of Feather Icons.

You can find the original docs [here](https://lucide.dev/docs) and repo [here](https://github.com/lucide-icons/lucide).

## Installation

Add `lucide_icons` to the list of dependencies in `mix.exs`:

```elixir dark
def deps do
  [
    {:lucide_icons, "~> 1.1"}
  ]
end
```

Then run `mix deps.get`.

## Usage

#### With Heex

```elixir dark
<Lucideicons.alert_triangle class="h-4 w-4" aria-hidden/>
```

where `alert_triangle` refers to a specific icon name.

> Icon names can be retrieved from `Lucideicons.icon_names/0`

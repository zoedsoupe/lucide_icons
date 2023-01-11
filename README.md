# Lucideicons

![CI](https://github.com/zoedsoupe/lucide_icons/actions/workflows/ci.yml/badge.svg)

This package adds a convenient way of using [Lucide](https://lucide.dev/) with your Phoenix and Phoenix.LiveView applications.

Lucide is "An open source icon library for displaying icons and symbols in digital and non-digital projects. It consists of 850+ Vector (svg) files", and is a fork of Feather Icons.

You can find the original docs [here](https://lucide.dev/docs) and repo [here](https://github.com/lucide-icons/lucide).

## Installation

Add `lucide_icons` to the list of dependencies in `mix.exs`:

```elixir dark
def deps do
  [
    {:lucide_icons, "~> 0.1.0"}
  ]
end
```

Then run `mix deps.get`.

## Usage

#### With Eex or Leex

```elixir dark
<%= Lucideicons.icon("academic-cap", type: "outline", class: "h-4 w-4") %>
```

#### With Heex

```elixir dark
<Lucideicons.LiveView.icon name="academic-cap" type="outline" class="h-4 w-4" />
```

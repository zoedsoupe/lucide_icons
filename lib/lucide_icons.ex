defmodule Lucideicons do
  use Phoenix.Component

  alias Lucideicons.Icon

  priv_dir = :code.priv_dir(:lucide_icons) |> List.to_string()
  icon_paths = Path.join(priv_dir, "node_modules/lucide-static/icons/*.svg") |> Path.wildcard()

  icons =
    for icon_path <- icon_paths do
      @external_resource Path.relative_to_cwd(icon_path)
      Icon.parse!(icon_path)
    end

  names = icons |> Enum.map(& &1.name) |> Enum.uniq()

  @icon_names names

  @doc "Returns a list of available icon names"
  @spec icon_names() :: [String.t()]
  def icon_names(), do: @icon_names

  for %Icon{name: name, file: file} <- icons do
    def unquote(name)(assigns) do
      attrs = Icon.opts_to_attrs(assigns)
      icon_svg = Icon.insert_attrs(unquote(file), attrs)

      assigns = assign(assigns, raw: icon_svg)

      ~H"""
      <%= @raw %>
      """
    end
  end
end

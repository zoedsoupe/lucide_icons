defmodule Lucideicons do
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

  @doc """
  Generates an icon.
  Options may be passed through to the SVG tag for custom attributes.
  ## Options
    * `:class` - the css class added to the SVG tag
  ## Examples
      icon("triangle", class: "h-4 w-4")
      #=> <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path d="M12 14l9-5-9-5-9 5 9 5z"/>
            <path d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222"/>
          </svg>
  """
  @spec icon(String.t(), keyword) :: Phoenix.HTML.safe()
  def icon(name, opts \\ []) when is_binary(name) and is_list(opts) do
    unless name in @icon_names do
      raise ArgumentError,
            "icon #{inspect(name)} does not exist."
    end

    build_icon(name, opts)
  end

  for %Icon{name: name, file: file} <- icons do
    defp build_icon(unquote(name), opts) do
      attrs = Icon.opts_to_attrs(opts)
      Icon.insert_attrs(unquote(file), attrs)
    end
  end
end

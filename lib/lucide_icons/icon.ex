defmodule Lucideicons.Icon do
  @moduledoc """
  This module defines the data structure and functions for working with icons stored as SVG files.
  """

  @doc """
  Defines the Lucideicons.Icon struct

  Its fields are:

      * `:file` - the binary of the icon

      * `:name` - the name of the icon

  """
  @fields ~w(file name version)a
  @enforce_keys @fields
  defstruct @fields

  @json (cond do
           Code.ensure_loaded?(JSON) -> JSON
           Code.ensure_loaded?(Jason) -> Jason
           Code.ensure_loaded?(Poison) -> Poison
           true -> raise "need a JSON library available, either JSON or Jason"
         end)

  @lucide_static_version :code.priv_dir(:lucide_icons)
                         |> List.to_string()
                         |> Path.join("package-lock.json")
                         |> Path.expand()
                         |> File.read!()
                         |> @json.decode!()
                         |> get_in(["packages", "node_modules/lucide-static", "version"])

  def latest_version, do: @lucide_static_version

  @type t :: %Lucideicons.Icon{file: binary, name: String.t()}

  @doc "Parses a SVG file and returns structured data"
  @spec parse!(Path.t()) :: Lucideicons.Icon.t()
  def parse!(filename) do
    file = File.read!(filename)

    name =
      filename
      |> Path.split()
      |> Enum.at(-1)
      |> String.split(".", trim: true)
      |> List.first()
      |> String.replace("-", "_")
      |> String.to_atom()

    [license, _icon] = String.split(file, "\n", parts: 2)
    ["v" <> version] = Regex.run(~r/v\d+.\d+.\d+/, license)

    struct!(__MODULE__, file: file, name: name, version: version)
  end

  # "Converts opts to HTML attributes"
  @spec assigns_to_attrs(map) :: list
  defp assigns_to_attrs(assigns) do
    for {key, value} <- assigns do
      key = Phoenix.HTML.Safe.to_iodata(key)
      value = Phoenix.HTML.Safe.to_iodata(value)
      [?\s, key, ?=, ?", value, ?"]
    end
  end

  defp format_attr_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> String.replace("_", "-")
  end

  @license "<!-- @license lucide-static v#{@lucide_static_version} - ISC -->\n"

  @doc "Inserts HTML attributes into an SVG icon"
  @spec insert_attrs(binary, map) :: Phoenix.HTML.safe()
  def insert_attrs("<svg" <> rest, %{} = assigns) do
    svg_attrs = parse_svg_attrs("<svg" <> rest)
    assigns = merge_assigns(Map.delete(assigns, :__changed__), svg_attrs)
    Phoenix.HTML.raw(["<svg", assigns_to_attrs(assigns)])
  end

  def insert_attrs(<<@license, rest::binary>>, assigns) do
    insert_attrs(rest, assigns)
  end

  def insert_attrs(icon, assigns) when is_binary(icon) do
    [_license, rest] = String.split(icon, "\n", parts: 2)
    insert_attrs(rest, assigns)
  end

  defp parse_svg_attrs(svg) when is_binary(svg) do
    svg
    |> String.trim()
    |> LazyHTML.from_fragment()
    |> LazyHTML.attributes()
    |> then(fn [attrs] -> Map.new(attrs) end)
  end

  defp merge_assigns(%{class: class} = assigns, %{"class" => lucide_class} = svg_attrs) do
    class = Enum.join([lucide_class, class], " ")
    assigns = Map.new(assigns, fn {k, v} -> {format_attr_key(k), v} end)

    svg_attrs
    |> Map.merge(assigns)
    |> Map.put("class", class)
  end

  defp merge_assigns(%{} = assigns, %{} = svg_attrs) do
    assigns = Map.new(assigns, fn {k, v} -> {format_attr_key(k), v} end)
    Map.merge(svg_attrs, assigns)
  end
end

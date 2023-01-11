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
  @fields ~w(file name)a
  @enforce_keys @fields
  defstruct @fields

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

    struct!(__MODULE__, file: file, name: name)
  end

  @doc "Converts opts to HTML attributes"
  @spec opts_to_attrs(keyword) :: list
  def opts_to_attrs(opts) do
    for {key, value} <- opts do
      key =
        key
        |> Atom.to_string()
        |> String.replace("_", "-")
        |> Phoenix.HTML.Safe.to_iodata()

      value = Phoenix.HTML.Safe.to_iodata(value)

      [?\s, key, ?=, ?", value, ?"]
    end
  end

  @doc "Inserts HTML attributes into an SVG icon"
  @spec insert_attrs(binary, keyword) :: Phoenix.HTML.safe()
  def insert_attrs("<svg" <> rest, attrs) do
    Phoenix.HTML.raw(["<svg", attrs, rest])
  end
end

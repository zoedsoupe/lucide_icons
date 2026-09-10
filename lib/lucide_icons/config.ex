defmodule Lucideicons.Config do
  @moduledoc false

  @json Application.compile_env(:lucide_icons, :json_library, JSON)

  @doc false
  def json_library, do: @json
end

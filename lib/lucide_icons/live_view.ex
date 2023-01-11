if Code.ensure_loaded?(Phoenix.LiveView) do
  defmodule Lucideicons.LiveView do
    @moduledoc """
    A LiveView component for rendering Heroicons.

    ## Examples

        <Heroicons.LiveView.icon name="alert-triangle" class="h-4 w-4" />
    """

    use Phoenix.Component

    def icon(assigns) do
      opts = assigns[:opts] || []
      class_opts = class_to_opts(assigns)

      opts = Keyword.merge(opts, class_opts)

      assigns = assign(assigns, opts: opts)

      ~H"""
      <%= Lucideicons.icon(@name, @opts) %>
      """
    end

    defp class_to_opts(%{class: class}) do
      [class: class]
    end

    defp class_to_opts(_no_class), do: []
  end
end

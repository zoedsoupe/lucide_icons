defmodule LucideiconsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "renders icon" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.alert_triangle />
      """)

    assert html =~ "<svg"
  end

  test "renders icon with class" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.alert_triangle class="h-4 w-4" />
      """)

    assert html =~ ~s(<svg class="h-4 w-4")
  end

  test "renders icon with assigns" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.alert_triangle aria_hidden={false} />
      """)

    assert html =~ ~s(<svg aria-hidden="false")
  end
end

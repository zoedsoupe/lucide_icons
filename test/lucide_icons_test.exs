defmodule LucideiconsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "renders icon" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity_square />
      """)

    assert html =~ "<svg"
  end

  test "renders icon with class" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity_square class="h-4 w-4" />
      """)

    assert html =~ "h-4 w-4"
  end

  test "renders icon with assigns" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity_square aria_hidden={false} />
      """)

    assert html =~ ~s(<svg aria-hidden="false")
  end

  test "renders icon that may be deprecated, with different package version" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.circle_alert />
      """)

    assert html =~ "<svg"
  end

  # https://github.com/zoedsoupe/lucide_icons/issues/15
  test "regression github issue of duplicated class attr (#15)" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity_square class="h-4 w-4" />
      """)

    refute html =~ ~s(<svg class="h-4 w-4")
    assert html =~ ~s(<svg class="lucide lucide-activity-square h-4 w-4")
  end
end

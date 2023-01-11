defmodule Lucideicons.LiveViewTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  alias Lucideicons.LiveView

  test "renders icon" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <LiveView.icon name="alert-triangle" />
      """)

    assert html =~ "<svg"
  end

  test "renders icon with class" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <LiveView.icon name="alert-triangle" class="h-4 w-4" />
      """)

    assert html =~ ~s(<svg class="h-4 w-4")
  end

  test "renders icon with opts" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <LiveView.icon name="alert-triangle" opts={[aria_hidden: true]} />
      """)

    assert html =~ ~s(<svg aria-hidden="true")
  end

  test "class prop overrides opts prop" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <LiveView.icon name="alert-triangle" class="hello" opts={[class: "world"]} />
      """)

    assert html =~ ~s(<svg class="hello")
  end

  test "raises if icon name does not exist" do
    assigns = %{}
    msg = ~s(icon "hello" does not exist.)

    assert_raise ArgumentError, msg, fn ->
      rendered_to_string(~H"""
      <LiveView.icon name="hello" />
      """)
    end
  end
end

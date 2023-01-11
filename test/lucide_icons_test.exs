defmodule LucideiconsTest do
  use ExUnit.Case, async: true

  @test_icon "alert-triangle"

  test "renders icon" do
    assert Lucideicons.icon(@test_icon)
           |> Phoenix.HTML.safe_to_string() =~ "<svg"
  end

  test "renders icon with attribute" do
    assert Lucideicons.icon(@test_icon, class: "h-4 w-4")
           |> Phoenix.HTML.safe_to_string() =~ ~s(<svg class="h-4 w-4")
  end

  test "converts opts to attributes" do
    assert Lucideicons.icon(@test_icon, aria_hidden: true)
           |> Phoenix.HTML.safe_to_string() =~ ~s(<svg aria-hidden="true")
  end

  test "raises if icon name does not exist" do
    msg = ~s(icon "hello" does not exist.)

    assert_raise ArgumentError, msg, fn ->
      Lucideicons.icon("hello")
    end
  end
end

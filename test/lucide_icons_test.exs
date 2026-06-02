defmodule LucideiconsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "renders icon" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity />
      """)

    assert html =~ "<svg"
  end

  test "renders icon with class" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity class="h-4 w-4" />
      """)

    assert html =~ "h-4 w-4"
  end

  test "renders icon with assigns" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity aria_hidden={false} />
      """)

    assert html =~ ~s(<svg aria-hidden="false")
  end

  # https://github.com/zoedsoupe/lucide_icons/issues/15
  test "regression github issue of duplicated class attr (#15)" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity class="h-4 w-4" />
      """)

    refute html =~ ~s(<svg class="h-4 w-4")
    assert html =~ ~s(<svg class="lucide lucide-activity h-4 w-4")
  end

  # https://github.com/zoedsoupe/lucide_icons/issues/24
  test "insert_attrs preserves SVG content when called directly with SVG string" do
    # This test directly calls insert_attrs with an SVG string starting with "<svg"
    # to verify the fix works even when hitting that code path directly
    svg_string = ~s(<svg class="test" viewBox="0 0 24 24"><path d="M12 2v20"/></svg>)
    assigns = %{class: "custom-class"}

    result = Lucideicons.Icon.insert_attrs(svg_string, assigns)
    html = Phoenix.HTML.safe_to_string(result)

    # Verify the SVG tag is properly closed
    assert html =~ ~r/<svg[^>]*>/

    # Verify the SVG content (path) is preserved
    assert html =~ ~r/<path/

    # Verify the SVG is properly closed
    assert html =~ ~r/<\/svg>/

    # Verify custom class was added
    assert html =~ "custom-class"
  end

  describe "class normalization" do
    test "accepts a flat class list" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.activity class={["h-4 w-4", "text-blue-500"]} />
        """)

      assert html =~ ~s(class="lucide lucide-activity h-4 w-4 text-blue-500")
    end

    test "drops `false` entries (Phoenix conditional-class pattern)" do
      assigns = %{filled?: false}

      html =
        rendered_to_string(~H"""
        <Lucideicons.heart class={["size-4", @filled? && "fill-current"]} />
        """)

      assert html =~ ~s(class="lucide lucide-heart size-4")
      refute html =~ "false"
    end

    test "drops `nil` and empty-string entries" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.heart class={["size-4", nil, ""]} />
        """)

      assert html =~ ~s(class="lucide lucide-heart size-4")
    end

    test "flattens nested lists" do
      assigns = %{flag?: true}

      html =
        rendered_to_string(~H"""
        <Lucideicons.heart class={[["size-4", "transition"], @flag? && "fill-current"]} />
        """)

      assert html =~ ~s(class="lucide lucide-heart size-4 transition fill-current")
    end

    test "handles nil class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.heart class={nil} />
        """)

      assert html =~ ~s(class="lucide lucide-heart")
    end
  end

  # https://github.com/zoedsoupe/lucide_icons/issues/24
  test "renders icon correctly with span element after it" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Lucideicons.activity class="h-4 w-4" />
      <span>Test content</span>
      """)

    # Verify the SVG is properly closed before the span
    assert html =~ ~r/<\/svg>\s*<span>/

    # Verify the span element is present and correct
    assert html =~ ~r/<span>Test content<\/span>/

    # Verify we don't have malformed HTML where SVG attributes leak into the span
    refute html =~ ~r/<svg[^>]*\s<=""/
    refute html =~ ~r/<span[^>]*<=""/

    # Verify both elements are present
    assert html =~ ~r/<svg[^>]*>/
    assert html =~ ~r/<span>/
  end

  describe "render/1" do
    test "renders an icon by name" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="activity" />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(class="lucide lucide-activity")
    end

    test "renders an icon by name with dashes or underscores in the name" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="alert-triangle" />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(class="lucide lucide-alert-triangle")

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="alert_triangle" />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(class="lucide lucide-alert-triangle")
    end

    test "accepts a string or atom name" do
      assigns = %{}

      from_string =
        rendered_to_string(~H"""
        <Lucideicons.render name="activity" />
        """)

      from_atom =
        rendered_to_string(~H"""
        <Lucideicons.render name={:activity} />
        """)

      assert from_string == from_atom
    end

    test "does not leak the name attribute into the SVG" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="activity" />
        """)

      refute html =~ ~r/<svg[^>]*\sname=/
    end

    test "merges additional attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="activity" class="h-4 w-4" aria_hidden={true} />
        """)

      assert html =~ ~s(class="lucide lucide-activity h-4 w-4")
      assert html =~ ~s(aria-hidden="true")
    end

    test "renders a comment fallback with the name for an unknown icon without raising" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render name="this_icon_does_not_exist" />
        """)

      refute html =~ "<svg"
      assert html =~ "<!-- Icon this_icon_does_not_exist not found -->"
    end
  end

  describe "render!/1" do
    test "renders an icon by name" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render! name="activity" />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(class="lucide lucide-activity")
    end

    test "does not leak the name attribute into the SVG" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <Lucideicons.render! name="activity" />
        """)

      refute html =~ ~r/<svg[^>]*\sname=/
    end

    test "raises for an unknown icon" do
      assigns = %{}

      assert_raise RuntimeError, ~r/this_icon_does_not_exist not found/, fn ->
        rendered_to_string(~H"""
        <Lucideicons.render! name="this_icon_does_not_exist" />
        """)
      end
    end
  end
end

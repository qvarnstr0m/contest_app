defmodule ContestAppWeb.ErrorJSONTest do
  use ContestAppWeb.ConnCase, async: true

  test "renders 404" do
    assert ContestAppWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ContestAppWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

defmodule ContestAppWeb.CommandCentralLiveTest do
  use ContestAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import ContestApp.PagesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_command_central(_) do
    command_central = command_central_fixture()
    %{command_central: command_central}
  end

  describe "Index" do
    setup [:create_command_central]

    test "lists all command_central", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/command_central")

      assert html =~ "Listing Command central"
    end

    test "saves new command_central", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/command_central")

      assert index_live |> element("a", "New Command central") |> render_click() =~
               "New Command central"

      assert_patch(index_live, ~p"/command_central/new")

      assert index_live
             |> form("#command_central-form", command_central: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#command_central-form", command_central: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/command_central")

      html = render(index_live)
      assert html =~ "Command central created successfully"
    end

    test "updates command_central in listing", %{conn: conn, command_central: command_central} do
      {:ok, index_live, _html} = live(conn, ~p"/command_central")

      assert index_live |> element("#command_central-#{command_central.id} a", "Edit") |> render_click() =~
               "Edit Command central"

      assert_patch(index_live, ~p"/command_central/#{command_central}/edit")

      assert index_live
             |> form("#command_central-form", command_central: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#command_central-form", command_central: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/command_central")

      html = render(index_live)
      assert html =~ "Command central updated successfully"
    end

    test "deletes command_central in listing", %{conn: conn, command_central: command_central} do
      {:ok, index_live, _html} = live(conn, ~p"/command_central")

      assert index_live |> element("#command_central-#{command_central.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#command_central-#{command_central.id}")
    end
  end

  describe "Show" do
    setup [:create_command_central]

    test "displays command_central", %{conn: conn, command_central: command_central} do
      {:ok, _show_live, html} = live(conn, ~p"/command_central/#{command_central}")

      assert html =~ "Show Command central"
    end

    test "updates command_central within modal", %{conn: conn, command_central: command_central} do
      {:ok, show_live, _html} = live(conn, ~p"/command_central/#{command_central}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Command central"

      assert_patch(show_live, ~p"/command_central/#{command_central}/show/edit")

      assert show_live
             |> form("#command_central-form", command_central: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#command_central-form", command_central: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/command_central/#{command_central}")

      html = render(show_live)
      assert html =~ "Command central updated successfully"
    end
  end
end

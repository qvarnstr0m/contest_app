defmodule ContestApp.PagesTest do
  use ContestApp.DataCase

  alias ContestApp.Pages

  describe "command_central" do
    alias ContestApp.Pages.CommandCentral

    import ContestApp.PagesFixtures

    @invalid_attrs %{}

    test "list_command_central/0 returns all command_central" do
      command_central = command_central_fixture()
      assert Pages.list_command_central() == [command_central]
    end

    test "get_command_central!/1 returns the command_central with given id" do
      command_central = command_central_fixture()
      assert Pages.get_command_central!(command_central.id) == command_central
    end

    test "create_command_central/1 with valid data creates a command_central" do
      valid_attrs = %{}

      assert {:ok, %CommandCentral{} = command_central} = Pages.create_command_central(valid_attrs)
    end

    test "create_command_central/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_command_central(@invalid_attrs)
    end

    test "update_command_central/2 with valid data updates the command_central" do
      command_central = command_central_fixture()
      update_attrs = %{}

      assert {:ok, %CommandCentral{} = command_central} = Pages.update_command_central(command_central, update_attrs)
    end

    test "update_command_central/2 with invalid data returns error changeset" do
      command_central = command_central_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_command_central(command_central, @invalid_attrs)
      assert command_central == Pages.get_command_central!(command_central.id)
    end

    test "delete_command_central/1 deletes the command_central" do
      command_central = command_central_fixture()
      assert {:ok, %CommandCentral{}} = Pages.delete_command_central(command_central)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_command_central!(command_central.id) end
    end

    test "change_command_central/1 returns a command_central changeset" do
      command_central = command_central_fixture()
      assert %Ecto.Changeset{} = Pages.change_command_central(command_central)
    end
  end
end

defmodule ContestApp.PagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ContestApp.Pages` context.
  """

  @doc """
  Generate a command_central.
  """
  def command_central_fixture(attrs \\ %{}) do
    {:ok, command_central} =
      attrs
      |> Enum.into(%{

      })
      |> ContestApp.Pages.create_command_central()

    command_central
  end
end

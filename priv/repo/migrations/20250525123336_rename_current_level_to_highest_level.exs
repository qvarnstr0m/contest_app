defmodule ContestApp.Repo.Migrations.RenameCurrentLevelToHighestLevel do
  use Ecto.Migration

  def change do
    rename table(:participants), :current_level, to: :highest_level
  end
end

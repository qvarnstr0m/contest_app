defmodule ContestApp.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :name, :string
      add :api_url, :string
      add :current_level, :integer
      add :highest_level_timestamp, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule ContestApp.Participants.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string
    field :api_url, :string
    field :current_level, :integer
    field :highest_level_timestamp, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :api_url, :current_level, :highest_level_timestamp])
    |> validate_required([:name, :api_url, :current_level, :highest_level_timestamp])
  end
end

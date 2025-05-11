defmodule ContestApp.Participants do
  import Ecto.Query, warn: false
  alias ContestApp.Repo
  alias ContestApp.Participants.Participant

  def register(name, api_url) do
    existing =
      from(p in Participant, where: p.name == ^name or p.api_url == ^api_url) |> Repo.one()

    if existing do
      {:error, "Participant already exists"}
    else
      %Participant{}
      |> Participant.changeset(%{
        name: name,
        api_url: api_url,
        current_level: 0,
        highest_level_timestamp: DateTime.utc_now()
      })
      |> Repo.insert()
    end
  end
end

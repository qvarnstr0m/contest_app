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
        highest_level: 0,
        highest_level_timestamp: DateTime.utc_now()
      })
      |> Repo.insert()
      |> case do
        {:ok, participant} ->
          ContestApp.ParticipantSupervisor.start_participant(participant)
          {:ok, participant}

        error ->
          error
      end
    end
  end

  def get_by_api_url(api_url) do
    Repo.get_by(Participant, api_url: api_url)
  end

  def list_all do
    Repo.all(Participant)
  end

  def update_highest_level!(participant, new_level) do
    changeset =
      Participant.changeset(participant, %{
        highest_level: new_level,
        highest_level_timestamp: DateTime.utc_now()
      })

    Repo.update!(changeset)
  end
end

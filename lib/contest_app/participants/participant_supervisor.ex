defmodule ContestApp.ParticipantSupervisor do
  use DynamicSupervisor

  alias ContestApp.ParticipantGenServer

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_existing_participants do
    for participant <- ContestApp.Participants.list_all() do
      start_participant(participant)
    end
  end

  def start_participant(participant) do
    spec = {
      ParticipantGenServer,
      participant
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_participant(pid) when is_pid(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end

defmodule ContestAppWeb.LeaderboardLive.Index do
  use ContestAppWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ContestApp.PubSub, "participants:leaderboard")
    end

    {:ok, assign(socket, participants: fetch_participants())}
  end

  @impl Phoenix.LiveView
  def handle_info({:leaderboard_update, _}, socket) do
    {:noreply, assign(socket, participants: fetch_participants())}
  end

  defp fetch_participants do
    ContestApp.Participants.list_all()
    |> Enum.sort_by(fn p -> {-p.highest_level, p.highest_level_timestamp} end)
  end
end

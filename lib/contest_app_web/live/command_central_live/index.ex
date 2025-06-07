defmodule ContestAppWeb.CommandCentralLive.Index do
  use ContestAppWeb, :live_view

  @impl Phoenix.LiveView

  def mount(_params, _session, socket) do
    ip =
      case get_connect_info(socket, :peer_data) do
        %{address: ip_address} -> :inet.ntoa(ip_address) |> to_string()
        _ -> "unknown_address"
      end

    api_url = "http://#{ip}:5029"
    participant = ContestApp.Participants.get_by_api_url(api_url)

    if participant && connected?(socket) do
      state = ContestApp.ParticipantGenServer.get_state(participant.id)
      ContestApp.ParticipantGenServer.subscribe(participant.id)

      show_final_message = show_final_message?(Enum.reverse(state.passed_tests))

      socket =
        socket
        |> assign_state(state)
        |> assign(
          ip: ip,
          show_final_message: show_final_message
        )

      {:ok, socket}
    else
      {:ok,
       assign(socket,
         ip: ip,
         participant: nil,
         next_test: nil,
         latest_test: nil,
         passed_tests: [],
         show_final_message: false
       )}
    end
  end

  defp assign_state(socket, state) do
    socket
    |> assign(
      participant: state.participant,
      next_test: state.next_test,
      latest_test: state.latest_result,
      passed_tests: Enum.reverse(state.passed_tests)
    )
  end

  @impl Phoenix.LiveView
  def handle_info({:state, state}, socket) do
    show_final_message = show_final_message?(Enum.reverse(state.passed_tests))

    {:noreply,
     socket
     |> assign_state(state)
     |> assign(show_final_message: show_final_message)}
  end

  defp show_final_message?(passed_tests) do
    latest_level = passed_tests |> Enum.map(& &1.test_level) |> Enum.max(fn -> 0 end)
    latest_level >= ContestApp.Tests.highest_level()
  end
end

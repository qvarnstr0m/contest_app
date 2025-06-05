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

      passed_tests = Enum.reverse(state.passed_tests)

      latest_passed_level =
        passed_tests
        |> Enum.map(& &1.test_level)
        |> Enum.max(fn -> 0 end)

      highest_possible_level = ContestApp.Tests.highest_level()
      show_final_message = latest_passed_level >= highest_possible_level

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
    IO.inspect(state.passed_tests, label: "passed")
    {:noreply, assign_state(socket, state)}
  end
end

defmodule ContestAppWeb.CommandCentralLive.Index do
  use ContestAppWeb, :live_view

  def mount(_params, _session, socket) do
    ip =
      case get_connect_info(socket, :peer_data) do
        %{address: ip_address} -> :inet.ntoa(ip_address) |> to_string()
        _ -> "unknown_address"
      end

    api_url = "http://#{ip}:5029"
    participant = ContestApp.Participants.get_by_api_url(api_url)

    if participant do
      state = ContestApp.ParticipantGenServer.get_state(participant.id)

      passed_tests = Enum.reverse(state.passed_tests)

      latest_passed_level =
        passed_tests
        |> Enum.map(& &1.test_level)
        |> Enum.max(fn -> 0 end)

      highest_possible_level = ContestApp.Tests.highest_level()
      show_final_message = latest_passed_level >= highest_possible_level

      {:ok,
       assign(socket,
         ip: ip,
         participant: state.participant,
         next_test: state.next_test,
         latest_test: state.latest_result,
         passed_tests: Enum.reverse(state.passed_tests),
         show_final_message: show_final_message
       )}
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
end

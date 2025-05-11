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

    {:ok,
     assign(
       socket,
       ip: ip,
       participant: participant,
       next_test: nil,
       latest_test: nil,
       passed_tests: []
     )}
  end
end

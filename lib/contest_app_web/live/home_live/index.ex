defmodule ContestAppWeb.HomeLive.Index do
  use ContestAppWeb, :live_view

  def mount(_params, _session, socket) do
    ip =
      case get_connect_info(socket, :peer_data) do
        %{address: address} -> :inet.ntoa(address) |> to_string()
        _ -> "unknown"
      end

    form = to_form(%{"name" => ""}, as: :participant)

    {:ok,
     assign(socket,
       ip: ip,
       form: form,
       feedback: nil
     )}
  end

  def handle_event("register", %{"participant" => %{"name" => name}}, socket) do
    ip = socket.assigns.ip
    api_url = "http://#{ip}:5029"

    case ContestApp.Participants.register(name, api_url) do
      {:ok, _participant} ->
        socket =
          socket
          |> put_flash(:info, "You are now registered! Redirecting...")
          |> push_redirect(to: "/command-central")

        {:noreply, socket}

      {:error, msg} ->
        {:noreply, assign(socket, feedback: msg)}
    end
  end
end

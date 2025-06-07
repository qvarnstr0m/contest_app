defmodule ContestAppWeb.HomeLive.Index do
  use ContestAppWeb, :live_view

  def mount(_params, _session, socket) do
    ip =
      case get_connect_info(socket, :peer_data) do
        %{address: ip_address} -> :inet.ntoa(ip_address) |> to_string()
        _ -> "not_found"
      end

    form = to_form(%{"name" => ""}, as: :participant)

    {:ok,
     assign(socket,
       ip: ip,
       form: form,
       feedback: nil,
       registered: false,
       redirect_in: nil
     )}
  end

  def handle_event("register", %{"participant" => %{"name" => name}}, socket) do
    ip = socket.assigns.ip
    api_url = "http://#{ip}:5029"

    case ContestApp.Participants.register(name, api_url) do
      {:ok, _participant} ->
        socket =
          socket
          |> assign(:registered, true)
          |> assign(:redirect_in, 10)

        Process.send_after(self(), :countdown_tick, 1000)

        {:noreply, socket}

      {:error, msg} ->
        {:noreply, assign(socket, feedback: msg)}
    end
  end

  def handle_info(:countdown_tick, %{assigns: %{redirect_in: 1}} = socket) do
    {:noreply, push_navigate(socket, to: "/command-central")}
  end

  def handle_info(:countdown_tick, %{assigns: %{redirect_in: n}} = socket)
      when is_integer(n) and n > 1 do
    Process.send_after(self(), :countdown_tick, 1000)
    {:noreply, assign(socket, :redirect_in, n - 1)}
  end
end

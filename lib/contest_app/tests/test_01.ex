defmodule ContestApp.Tests.Test01 do
  @behaviour ContestApp.Tests.Test

  @impl true
  def name, do: "Initial contact"

  @impl true
  def endpoint, do: "/ok"

  @impl true
  def http_method, do: :get

  @impl true
  def level, do: 1

  @impl true
  def description do
    ~S"""
    The terminal buzzes satisfyingly. A new prompt pulses:
    **INITIAL CONTACT ESTABLISHED**

    Something—someone—is out there, listening. You're being asked to respond, to prove you're alive on this frequency. Your system must expose a `GET /ok` endpoint that responds with a simple `200 OK`.

    A whispered hunch drifts in: *"Check the ReadMe. It might be acually be useful..."*
    """
  end

  @impl true
  def expected_result, do: "200 OK"

  @impl true
  def run_test(api_url, participant_id) do
    IO.inspect(api_url)
    url = api_url <> endpoint()
    request = Req.new(retry: false, url: url)

    case Req.get(request) do
      {:ok, %{status: 200}} ->
        {:ok,
         %{
           participant_id: participant_id,
           name: name(),
           level: level(),
           is_success: true,
           message: "Got a valid 200 OK response"
         }}

      {:ok, %{status: status}} ->
        {:error, "Expected 200 OK but got #{status}"}

      {:error, reason} ->
        {:error, "HTTP error: #{inspect(reason)}"}
    end
  end
end

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
    """
    After providing your name, the prompt flickers and shifts, unveiling a new message on the screen.
    Initial contact. It appears the system is now awaiting your next move, prompting you to establish
    an endpoint for the GET request. You need to set up an endpoint that responds with a 200 Ok.
    You get a strange feeling that your progress may be dependent on 'ReadMe', whatever that could mean...
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

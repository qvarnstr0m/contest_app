defmodule ContestApp.Tests.Test03 do
  @behaviour ContestApp.Tests.Test

  @impl true
  def name, do: "Echo to earth"

  @impl true
  def endpoint, do: "/transmissions"

  @impl true
  def http_method, do: :post

  @impl true
  def level, do: 3

  @impl true
  def description do
    """
    The link to Earth stabilizes. A message comes through—structured and deliberate.

    You're expected to receive a Transmission: an object with an `id` (integer), a `signal_code` (string), and a `message` (string). Set up a `POST /transmissions` endpoint that accepts this payload and echoes it back exactly as received, responding with a `201 Created` status.

    Communication is now two-way. Don’t break the loop.
    """
  end

  @impl true
  def expected_result, do: "201 OK with the transmission that was posted."

  @impl true
  @spec run_test(binary(), any()) ::
          {:error, <<_::64, _::_*8>>}
          | {:ok,
             %{
               is_success: true,
               level: 3,
               message: <<_::216>>,
               name: <<_::104>>,
               participant_id: any()
             }}
  def run_test(api_url, participant_id) do
    transmission = %{
      "id" => 1,
      "signal_code" => "signalcode",
      "message" => "message"
    }

    url = api_url <> endpoint()
    request = Req.new(retry: false, url: url, json: transmission)

    case Req.post(request) do
      {:ok, %{status: 201, body: response_body}} ->
        case response_body do
          %{"id" => _, "signal_code" => "signalcode", "message" => "message"} ->
            {:ok,
             %{
               participant_id: participant_id,
               name: name(),
               level: level(),
               is_success: true,
               message: "Got a valid 200 OK response"
             }}

          _ ->
            {:error,
             "Expected transmission echoed back with correct values, got #{inspect(response_body)}"}
        end

      {:ok, %{status: status, body: body}} ->
        {:error, "Expected 201 Created but got #{status} with body #{inspect(body)}"}

      {:error, reason} ->
        {:error, "HTTP error: #{inspect(reason)}"}
    end
  end
end

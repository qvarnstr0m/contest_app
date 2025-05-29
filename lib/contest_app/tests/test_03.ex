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
    Having established a fragile connection to earth, from the next prompt it seems that whoever is trying to
    communicate with you wants you to be able to handle the posting of a request. The request will hold something
    they refer to a Transmission, something that holds an id(int), signal_code(string) and message(string).
    You are to respond with a 201 Created status code and the posted entry.
    """
  end

  @impl true
  def expected_result, do: "201 OK with the transmission that was posted."

  @impl true
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
          %{"id" => 1, "signal_code" => "signalcode", "message" => "message"} ->
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

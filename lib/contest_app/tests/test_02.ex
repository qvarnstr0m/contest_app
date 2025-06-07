defmodule ContestApp.Tests.Test02 do
  @behaviour ContestApp.Tests.Test

  @impl true
  def name, do: "An ancient JSON response"

  @impl true
  def endpoint, do: "/transmissions"

  @impl true
  def http_method, do: :get

  @impl true
  def level, do: 2

  @impl true
  def description do
    ~S"""
    The terminal stutters, then locks into rhythm. A new message pulses onto the screen:
    “Data expected. Format: JSON.”

    You suspect the transmission isn’t from a machine — but from something or someone still trying to maintain order out here.

    Implement a `GET /transmissions` endpoint that responds with a valid `200 OK` and a JSON payload.
    The contents? Irrelevant — for now. The format? Sacred. Ancient. Required.
    """
  end

  @impl true
  def expected_result, do: "200 OK with json formated content"

  @impl true
  def run_test(api_url, participant_id) do
    url = api_url <> endpoint()

    request =
      Req.new(
        url: url,
        retry: false,
        decode_body: false
      )

    case Req.get(request) do
      {:ok, %{status: 200, headers: headers, body: raw_body}} ->
        content_type = get_content_type(headers)

        if is_json?(content_type) do
          case Jason.decode(raw_body) do
            {:ok, _json} ->
              {:ok,
               %{
                 participant_id: participant_id,
                 name: name(),
                 level: level(),
                 is_success: true,
                 message: "Got 200 OK with valid JSON content: #{content_type}"
               }}

            {:error, error} ->
              {:error, "Content-Type is JSON but body is not valid JSON: #{inspect(error)}"}
          end
        else
          {:error, "Got 200 OK but content-type is not JSON: #{content_type}"}
        end

      {:ok, %{status: status, headers: headers}} ->
        content_type = get_content_type(headers)
        {:error, "Expected 200 OK with JSON, got #{status} with content-type: #{content_type}"}

      {:error, reason} ->
        {:error, "HTTP error: #{inspect(reason)}"}
    end
  end

  defp get_content_type(headers) do
    headers
    |> Enum.find(fn {key, _} -> String.downcase(key) == "content-type" end)
    |> case do
      {_, [value | _]} -> value
      {_, value} when is_binary(value) -> value
      _ -> "none"
    end
  end

  defp is_json?(content_type) do
    content_type
    |> String.downcase()
    |> String.starts_with?("application/json")
  end
end

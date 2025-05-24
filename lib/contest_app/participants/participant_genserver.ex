defmodule ContestApp.ParticipantGenServer do
  use GenServer

  def start_link(participant) do
    GenServer.start_link(__MODULE__, participant, name: via_tuple(participant.id))
  end

  defp via_tuple(id), do: {:via, Registry, {ContestApp.ParticipantRegistry, id}}

  @impl true
  def init(participant) do
    schedule_test()
    {:ok, participant}
  end

  @impl true
  def handle_info(:run_tests, participant) do
    run_tests_until_fail(participant)
    schedule_test()
    {:noreply, participant}
  end

  defp schedule_test do
    Process.send_after(self(), :run_tests, :timer.seconds(10))
  end

  defp run_tests_until_fail(participant) do
    tests = ContestApp.Tests.all()
    IO.inspect(tests, label: "Available tests")

    Enum.reduce_while(tests, nil, fn test_module, _acc ->
      case test_module.run_test(participant.api_url, participant.id) do
        {:ok, result} ->
          IO.puts("""
          ✅ Passed test:
          - Test: #{test_module.name()}
          - Participant: #{participant.name} (ID: #{participant.id})
          - Level: #{test_module.level()}
          """)

          {:cont, result}

        {:error, reason} ->
          IO.puts("""
          ❌ Failed test:
          - Test: #{test_module.name()}
          - Participant: #{participant.name} (ID: #{participant.id})
          - Level: #{test_module.level()}
          - Reason: #{inspect(reason)}
          """)

          {:halt, reason}
      end
    end)
  end
end

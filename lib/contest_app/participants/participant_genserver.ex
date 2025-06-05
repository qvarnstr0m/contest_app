defmodule ContestApp.ParticipantGenServer do
  use GenServer

  # Public API
  def start_link(participant) do
    GenServer.start_link(__MODULE__, participant, name: via_tuple(participant.id))
  end

  def subscribe(participant_id) do
    Phoenix.PubSub.subscribe(ContestApp.PubSub, "participant:#{participant_id}")
  end

  def get_state(participant_id) do
    GenServer.call(via_tuple(participant_id), :get_state)
  end

  defp via_tuple(id), do: {:via, Registry, {ContestApp.ParticipantRegistry, id}}

  defp broadcast(state) do
    Phoenix.PubSub.broadcast(
      ContestApp.PubSub,
      "participant:#{state.participant.id}",
      {:state, state}
    )
  end

  defp broadcast_leaderboard_update(participant_id) do
    Phoenix.PubSub.broadcast(
      ContestApp.PubSub,
      "participants:leaderboard",
      {:leaderboard_update, %{id: participant_id}}
    )
  end

  # GenServer Callbacks
  @impl true
  def init(participant) do
    schedule_test()

    {:ok,
     %{
       participant: participant,
       next_test: nil,
       latest_result: nil,
       passed_tests: []
     }}
  end

  @impl true
  def handle_info(:run_tests, state) do
    new_state = run_tests_until_fail(state)
    schedule_test()
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  # Helpers

  defp schedule_test do
    Process.send_after(self(), :run_tests, :timer.seconds(10))
  end

  defp run_tests_until_fail(state) do
    tests = ContestApp.Tests.all()

    fresh_state = %{state | passed_tests: []}

    Enum.reduce_while(tests, fresh_state, fn test_module, acc_state ->
      case test_module.run_test(acc_state.participant.api_url, acc_state.participant.id) do
        {:ok, result} ->
          IO.puts("""
          ✅ Passed test:
          - Test: #{test_module.name()}
          - Participant: #{acc_state.participant.name} (ID: #{acc_state.participant.id})
          - Level: #{test_module.level()}
          """)

          passed_result = %{
            test_name: test_module.name(),
            test_level: test_module.level(),
            is_success: true,
            message: result.message || "Success",
            participant_id: acc_state.participant.id
          }

          # Check if new level is a high score
          updated_participant =
            if test_module.level() > acc_state.participant.highest_level do
              # Update DB
              ContestApp.Participants.update_highest_level!(
                acc_state.participant,
                test_module.level()
              )
            else
              acc_state.participant
            end

          if test_module.level() > acc_state.participant.highest_level do
            broadcast_leaderboard_update(acc_state.participant.id)
          end

          updated = %{
            acc_state
            | participant: updated_participant,
              passed_tests: [passed_result | acc_state.passed_tests],
              latest_result: passed_result,
              next_test: nil
          }

          broadcast(updated)

          {:cont, updated}

        {:error, reason} ->
          IO.puts("""
          ❌ Failed test:
          - Test: #{test_module.name()}
          - Participant: #{acc_state.participant.name} (ID: #{acc_state.participant.id})
          - Level: #{test_module.level()}
          - Reason: #{inspect(reason)}
          """)

          failed_result = %{
            test_name: test_module.name(),
            test_level: test_module.level(),
            is_success: false,
            message: reason
          }

          updated = %{
            acc_state
            | latest_result: failed_result,
              next_test: %{
                name: test_module.name(),
                level: test_module.level(),
                description: test_module.description(),
                expected_result: test_module.expected_result(),
                endpoint: test_module.endpoint(),
                method: test_module.http_method()
              }
          }

          broadcast(updated)

          {:halt, updated}
      end
    end)
  end
end

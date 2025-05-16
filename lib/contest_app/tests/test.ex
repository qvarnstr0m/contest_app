defmodule ContestApp.Tests.Test do
  @callback name() :: String.t()
  @callback endpoint() :: String.t()
  @callback http_method() :: :get | :post | :put | :delete
  @callback level() :: integer()
  @callback description() :: String.t()
  @callback expected_result() :: String.t()
  @callback run_test(api_url :: String.t(), participant_id :: integer()) ::
              {:ok, map() | {:error, String.t()}}
end

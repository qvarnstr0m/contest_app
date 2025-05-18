defmodule ContestApp.Tests do
  @moduledoc """
  Returns the list of test modules that implement the ContestApp.Tests.Test behaviour.
  """

  @type test_module :: module()

  @spec all() :: [test_module()]
  def all do
    [
      ContestApp.Tests.Test01
      # Add more later
    ]
  end
end

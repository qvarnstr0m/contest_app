defmodule ContestApp.Tests do
  @moduledoc """
  Returns the list of test modules that implement the ContestApp.Tests.Test behaviour.
  """

  @type test_module :: module()

  @spec all() :: [test_module()]
  def all do
    [
      ContestApp.Tests.Test01,
      ContestApp.Tests.Test02,
      ContestApp.Tests.Test03
    ]
  end

  def highest_level do
    all()
    |> Enum.map(& &1.level())
    |> Enum.max()
  end
end

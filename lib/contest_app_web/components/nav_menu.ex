defmodule NavMenu do
  use Phoenix.Component

  attr :current_path, :string, default: "/"

  def nav(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center md:px-20">
      <nav class="flex flex-row justify-between py-10 w-full">
        <div>
          <.link href="/" class="text-xl hover:blur-[2px]">Home</.link>
        </div>
        <div>
          <.link href="/command-central" class="text-xl hover:blur-[2px]">Command Central</.link>
        </div>
        <div>
          <.link href="/" class="text-xl hover:blur-[2px]">Leaderboard</.link>
        </div>
        <div>
          <.link href="/" class="text-xl hover:blur-[2px]">Participants</.link>
        </div>
      </nav>
    </div>
    """
  end
end

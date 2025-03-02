defmodule NavMenu do
  use Phoenix.Component

  attr :current_path, :string, default: "/"

  def nav(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center md:px-20">
      <nav class="flex flex-row justify-between py-10 w-full">
        <div>
          <.link href="/" class="">Home</.link>
        </div>
        <div>
          <.link href="/" class="">Home</.link>
        </div>
        <div>
          <.link href="/" class="">Home</.link>
        </div>
        <div>
          <.link href="/" class="">Home</.link>
        </div>
      </nav>
    </div>
    """
  end
end

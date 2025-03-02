defmodule Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <div class="flex flex-row justify-end py-4 md:px-20">
      <p>Phoenix Framework v{Application.spec(:phoenix, :vsn)}</p>
      <div>
        <.link href="/readme" class="ms-2">ReadMe</.link>
      </div>
    </div>
    """
  end
end

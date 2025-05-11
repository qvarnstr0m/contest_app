defmodule Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <div class="flex flex-row justify-end py-4 md:px-20">
      <p>
        <a
          href="https://www.phoenixframework.org/"
          class="underline hover:no-underline"
          target="_blank"
          rel="noopener noreferrer"
        >
          Phoenix Framework

          v{Application.spec(:phoenix, :vsn)}
        </a>
      </p>
      <div>
        <.link href="/readme" class="ms-2 underline hover:no-underline">ReadMe</.link>
      </div>
    </div>
    """
  end
end

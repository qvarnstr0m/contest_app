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
    </div>
    """
  end
end

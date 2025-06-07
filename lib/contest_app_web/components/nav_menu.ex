defmodule NavMenu do
  use Phoenix.Component

  attr :current_path, :string, default: "/"

  def nav(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center md:px-20">
      <nav class="flex flex-row justify-between py-8 w-full space-x-6">
        <.nav_link href="/" label="Home" current_path={@current_path} />
        <.nav_link href="/command-central" label="Command Central" current_path={@current_path} />
        <.nav_link href="/leaderboard" label="Leaderboard" current_path={@current_path} />
        <.nav_link href="/readme" label="ReadMe" current_path={@current_path} />
      </nav>
    </div>
    """
  end

  attr :href, :string, required: true
  attr :label, :string, required: true
  attr :current_path, :string, required: true

  def nav_link(assigns) do
    ~H"""
    <.link
      href={@href}
      class={
        "text-xl hover:blur-[2px] transition-all " <>
        if @current_path == @href do
          " underline"
        else
          ""
        end
      }
    >
      {@label}
    </.link>
    """
  end
end

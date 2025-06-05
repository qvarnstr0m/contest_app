defmodule ContestAppWeb.ReadmeController do
  use ContestAppWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end

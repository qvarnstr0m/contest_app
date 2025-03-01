defmodule ContestApp.Repo do
  use Ecto.Repo,
    otp_app: :contest_app,
    adapter: Ecto.Adapters.Postgres
end

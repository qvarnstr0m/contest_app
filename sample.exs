#!/usr/bin/env elixir
Application.put_env(:phoenix, :json_library, Jason)

Application.put_env(:sample, SamplePhoenix.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 5029],
  server: true,
  secret_key_base: String.duplicate("a", 64)
)

Mix.install([
  {:plug_cowboy, "~> 2.5"},
  {:jason, "~> 1.0"},
  {:phoenix, "~> 1.7.0"}
])

defmodule SamplePhoenix.SampleController do
  use Phoenix.Controller

  def ok(conn, _) do
    send_resp(conn, 200, "Hello, World!")
  end

  def fav(conn, _) do
    send_resp(conn, 200, "Hello, World!")
  end
end

defmodule Router do
  use Phoenix.Router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SamplePhoenix do
    pipe_through(:api)

    get("/ok", SampleController, :ok)

    # Prevent a horrible error because ErrorView is missing
    get("/favicon.ico", SampleController, :fav)
  end
end

defmodule SamplePhoenix.Endpoint do
  use Phoenix.Endpoint, otp_app: :sample
  plug(Router)
end

{:ok, _} = Supervisor.start_link([SamplePhoenix.Endpoint], strategy: :one_for_one)
Process.sleep(:infinity)

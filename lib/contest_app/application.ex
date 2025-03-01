defmodule ContestApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ContestAppWeb.Telemetry,
      ContestApp.Repo,
      {DNSCluster, query: Application.get_env(:contest_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ContestApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ContestApp.Finch},
      # Start a worker by calling: ContestApp.Worker.start_link(arg)
      # {ContestApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ContestAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContestApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContestAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

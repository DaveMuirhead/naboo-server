defmodule Naboo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Commanded application
      Naboo.App,

      # Start the Ecto repository
      Naboo.Repo,

      # Start the Telemetry supervisor
      NabooWeb.Telemetry,

      # Start the Endpoint (http/https)
      NabooWeb.Endpoint

      # Start a worker by calling: Naboo.Worker.start_link(arg)
      # {Naboo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Naboo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NabooWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Naboo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Naboo.Repo,

      # Start the Telemetry supervisor
      NabooWeb.Telemetry,

      # Start the PubSub system
      {Phoenix.PubSub, name: Naboo.PubSub},

      # Start the Endpoint (http/https)
      NabooWeb.Endpoint,
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

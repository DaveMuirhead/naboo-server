# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :naboo,
  ecto_repos: [Naboo.Repo],
  event_stores: [Naboo.EventStore]

config :naboo, Naboo.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Naboo.EventStore
  ],
  pub_sub: :local,
  registry: :local

# Configures the endpoint
config :naboo, NabooWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M+VBaBKapyHthgDpVI0jDzaUfruiVKnGnPnGH6zXe3+WVD69p/Z6q+ayLzEgpE96",
  render_errors: [view: NabooWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Naboo.PubSub,
  live_view: [signing_salt: "8IVIz68/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Naboo.Repo

config :vex,
  sources: [
    Naboo.Support.Validators,
    Vex.Validators
  ]
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import configuration for Ueberauth and Guardian with Auth0 as Identify Management service
import_config "ueberauth-local.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

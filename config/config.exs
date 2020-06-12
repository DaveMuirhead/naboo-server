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
  render_errors: [view: NabooWeb.ErrorView, format: "json", accepts: ~w(json), layout: false],
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

# Bamboo Mailer configuration
config :naboo, NabooWeb.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "mail.brsg.io",
  hostname: "brsg.io",
  port: 465,
  username: {:system, "APPS_SMTP_USERNAME"},
  password: {:system, "APPS_SMTP_PASSWORD"},
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 1,
  no_mx_lookups: false,
  auth: :always

# Import configuration for Ueberauth and Guardian with Auth0 as Identify Management service
#import_config "ueberauth-local.exs"

config :naboo, Naboo.Auth.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Naboo",
  ttl: {7, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "QkOEq+IOjvDrHnOJNbH3bAT5QQ2xMb7gCvrAFusw7X95Q6TOljy7WGnYP7RLSGPI"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

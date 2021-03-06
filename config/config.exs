# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :naboo,
  ecto_repos: [Naboo.Repo]

# Configures the endpoint
config :naboo, NabooWeb.Endpoint,
  url: [host: "dave.brsg.io"],
  secret_key_base: "M+VBaBKapyHthgDpVI0jDzaUfruiVKnGnPnGH6zXe3+WVD69p/Z6q+ayLzEgpE96",
  render_errors: [view: NabooWeb.ErrorView, format: "json", accepts: ~w(json), layout: false],
  pubsub_server: Naboo.PubSub,
  live_view: [signing_salt: "8IVIz68/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import configuration for Bamboo mailer
import_config "bamboo.exs"

# Import configuration for Guardian
import_config "guardian.exs"

# Import configuration for Arc
import_config "arc.exs"

# Import configuration for ExAws
#import_config "exaws.exs"

# Import configuration for Ueberauth using local identify management
#import_config "ueberauth-local.exs"

# Import configuration for Ueberauth using Auth0
#import_config "ueberauth-local.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

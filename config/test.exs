use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :naboo, NabooWeb.Endpoint,
  http: [port: 4004],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure the event store database
config :naboo, Naboo.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "naboo",
  password: "naboo",
  database: "naboo_eventstore_test",
  hostname: "localhost",
  port: 5434,
  pool_size: 10

# Configure the read store database
config :naboo, Naboo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "naboo",
  password: "naboo",
  database: "naboo_readstore_test",
  hostname: "localhost",
  port: 5434,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10


use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :naboo, NabooWeb.Endpoint,
  http: [port: 4004],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :naboo, Naboo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "naboo",
  password: "naboo",
  database: "naboo_test",
  hostname: "localhost",
  port: 5434,
  pool_size: 10

config :argon2_elixir, t_cost: 1, m_cost: 8
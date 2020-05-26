use Mix.Config

config :ueberauth, Ueberauth,
  base_path: "/v1/auth",
  providers: [
    auth0: {Ueberauth.Strategy.Auth0, []}
  ]

config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  domain: System.get_env("NABOO_AUTH0_DOMAIN"),
  client_id: System.get_env("NABOO_AUTH0_CLIENT_ID"),
  client_secret: System.get_env("NABOO_AUTH0_CLIENT_SECRET")

config :naboo, Naboo.Auth.Guardian,
  allowed_algos: ["RS256"],
  verify_module: Guardian.JWT,
  issuer: System.get_env("NABOO_AUTH0_DOMAIN"),
  verify_issuer: false,
  secret_key: System.get_env("NABOO_AUTH0_CLIENT_SECRET") |> Base.url_decode64 |> elem(1),
  serializer: Naboo.Auth.Guardian


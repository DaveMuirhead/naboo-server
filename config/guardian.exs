use Mix.Config

config :naboo, Naboo.Auth.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Naboo",
  ttl: {7, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "QkOEq+IOjvDrHnOJNbH3bAT5QQ2xMb7gCvrAFusw7X95Q6TOljy7WGnYP7RLSGPI"

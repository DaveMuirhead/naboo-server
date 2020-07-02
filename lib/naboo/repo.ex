defmodule Naboo.Repo do
  use Ecto.Repo,
    otp_app: :naboo,
    adapter: Ecto.Adapters.Postgres
end

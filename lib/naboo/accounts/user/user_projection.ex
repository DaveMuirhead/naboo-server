defmodule Naboo.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts_users" do
    field :email, :string, unique: true
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string

    timestamps()
  end

end

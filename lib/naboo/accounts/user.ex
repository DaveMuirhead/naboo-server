defmodule Naboo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts_users" do
    field :email, :string, unique: true
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :hashed_password, :first_name, :last_name])
    |> validate_required([:email, :hashed_password])
  end
end

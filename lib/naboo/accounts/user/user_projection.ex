defmodule Naboo.Accounts.Projections.User do
  use Ecto.Schema
  @derive {Phoenix.Param, key: :uuid}
  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts_users" do
    field :account_type, :string
    field :active, :boolean
    field :email, :string, unique: true
    field :email_verified, :boolean
    field :full_name, :string
    field :hashed_password, :string
    field :image_url, :string
    field :nickname, :string

    timestamps()
  end

end

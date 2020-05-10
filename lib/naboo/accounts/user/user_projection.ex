defmodule Naboo.Accounts.Projections.User do
  use Ecto.Schema
  @derive {Phoenix.Param, key: :uuid}
  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts_users" do
    field :email, :string, unique: true
    field :first_name, :string
    field :google_uid, :string
    field :hashed_password, :string
    field :image_url, :string
    field :last_name, :string

    timestamps()
  end

end

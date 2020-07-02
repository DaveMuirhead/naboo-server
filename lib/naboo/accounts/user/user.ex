defmodule Naboo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Naboo.Accounts
  alias Naboo.Accounts.User
  alias Naboo.Auth.Authenticator

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]

  schema "users" do
    field :account_type, :string
    field :active, :boolean, default: false
    field :email, :string, unique: true
    field :email_verified, :boolean, default: false
    field :full_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :picture, :string
    field :nickname, :string

    timestamps()
  end

  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  @doc false
  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:account_type, :email, :full_name, :password])
#    |> put_uuid()
    |> put_pass_hash()
    |> validate_required([:account_type, :email, :full_name, :password_hash, :password, :uuid])
    |> validate_email()
    |> validate_password()
  end

#  https://github.com/riverrun/phauxth-example/blob/master/lib/forks_the_egg_sample/accounts/user.ex

  def confirm_changeset(%__MODULE__{} = user, %{uuid: uuid, active: active, email_verified: email_verified} = attrs) do
    change(user, %{uuid: uuid, active: active, email_verified: email_verified})
  end

#  def password_reset_changeset(%__MODULE__{} = user, reset_sent_at) do
#    change(user, %{reset_sent_at: reset_sent_at})
#  end

#  def update_password_changeset(%__MODULE__{} = user, attrs) do
#    user
#    |> cast(attrs, [:password])
#    |> validate_required([:password])
#    |> validate_password(:password)
#    |> put_pass_hash()
#    |> change(%{reset_sent_at: nil})
#  end


  defp put_uuid(changeset) do
    change(changeset, %{uuid: UUID.uuid4()})
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Authenticator.hash_password(password)})
  end

  defp put_pass_hash(changeset), do: changeset

  defp validate_password(changeset) do
    changeset
    |> validate_password_length()
    |> validate_password_strength()
  end

  defp validate_password_length(changeset) do
    password = get_field(changeset, :password)
    if String.length(password) >= 8 do
      changeset
    else
      add_error(changeset, :password, "must be 8 characters or longer")
    end
  end

  defp validate_password_strength(changeset) do
    password = get_field(changeset, :password)
    with true <- String.match?(password, ~r/[[:lower:]]+/),
         true <- String.match?(password, ~r/[[:upper:]]+/),
         true <- String.match?(password, ~r/[[:digit:]]+/),
         true <- String.match?(password, ~r/[[:punct:]]+/)
    do
      changeset
    else
      _ -> add_error(changeset, :password, "is too weak")
    end
  end

  defp validate_email(changeset) do
    changeset
    |> validate_email_format()
    |> validate_email_available()
  end

  defp validate_email_format(changeset) do
    email = get_field(changeset, :email)
    case String.match?(email, ~r/\S+@\S+\.\S+/) do
      true -> changeset
      false -> add_error(changeset, :email, "not a valid email; expecting somebody@someco.tld")
    end
  end

  defp validate_email_available(changeset) do
    email = get_field(changeset, :email)
    case email_registered?(email) do
      true -> add_error(changeset, :email, "is already registered")
      false -> changeset
    end
  end

  def email_registered?(email) do
    case Accounts.user_by_email(email) do
      %User{email: ^email} -> true
      nil -> false
    end
  end

end

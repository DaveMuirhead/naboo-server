defmodule Naboo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Naboo.Accounts
  alias Naboo.Accounts.User
  alias Naboo.Auth.Authenticator

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Phoenix.Param, key: :uuid}

  schema "users" do
    field :account_type, :string
    field :active, :boolean, default: false
    field :email, :string, unique: true
    field :email_verified, :boolean, default: false
    field :full_name, :string
    field :nickname, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone1, :string
    field :picture, :string

    timestamps()
  end

  def start_registration_changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:account_type, :email, :full_name, :password, :picture, :nickname, :phone1])
    |> validate_required([:account_type, :email, :password])
    |> validate_email()
    |> validate_password()
    |> validate_picture()
    |> put_pass_hash()
  end

  def complete_registration_changeset(%__MODULE__{} = user, %{uuid: uuid, active: active, email_verified: email_verified} = attrs) do
    change(user, %{uuid: uuid, active: active, email_verified: email_verified})
  end

  def update_changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:full_name, :picture, :nickname, :phone1])
    |> validate_picture()
  end

  def password_update_changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
    |> put_pass_hash()
  end

  def email_update_changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_email()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Authenticator.hash_password(password)})
  end

  defp put_pass_hash(changeset), do: changeset

  defp validate_password(changeset) do
    password_change = get_change(changeset, :password)
    if (password_change != nil ) do
      changeset
      |> validate_password_length()
      |> validate_password_strength()
    else
      changeset
    end
  end

  defp validate_password_length(changeset) do
    password_change = get_change(changeset, :password)
    if String.length(password_change) >= 8 do
      changeset
    else
      add_error(changeset, :password, "must be 8 characters or longer")
    end
  end

  defp validate_password_strength(changeset) do
    password_change = get_change(changeset, :password)
    with true <- String.match?(password_change, ~r/[[:lower:]]+/),
         true <- String.match?(password_change, ~r/[[:upper:]]+/),
         true <- String.match?(password_change, ~r/[[:digit:]]+/),
         true <- String.match?(password_change, ~r/[[:punct:]]+/)
    do
      changeset
    else
      _ -> add_error(changeset, :password, "is too weak")
    end
  end

  defp validate_email(changeset) do
    email_change = get_change(changeset, :email)
    if (email_change != nil) do
      changeset
      |> validate_email_format()
      |> validate_email_available()
    else
      changeset
    end
  end

  defp validate_email_format(changeset) do
    email_change = get_change(changeset, :email)
    case String.match?(email_change, ~r/\S+@\S+\.\S+/) do
      true -> changeset
      false -> add_error(changeset, :email, "not a valid email address; expecting format local-part@domain.tld")
    end
  end

  defp validate_email_available(changeset) do
    email_change = get_change(changeset, :email)
    case email_registered?(email_change) do
      true -> add_error(changeset, :email, "is already registered")
      false -> changeset
    end
  end

  def email_registered?(email_change) do
    case Accounts.user_by_email(email_change) do
      %User{email: ^email_change} -> true
      nil -> false
    end
  end

  defp validate_picture(changeset) do
    picture_change = get_change(changeset, :picture)
    if (picture_change != nil) do
      case URI.parse(picture_change) do
        %URI{scheme: nil} -> add_error(changeset, :picture, "must have scheme")
        %URI{host: nil} -> add_error(changeset, :picture, "must have host")
        %URI{path: nil} -> add_error(changeset, :picture, "must have path")
        uri -> changeset
      end
    else
      changeset
    end
  end

end

defmodule Naboo.Auth.Authenticator do
  @moduledoc """
  Basic authentication using the bcrypt password hashing function.
  """

  alias Argon2
  alias Naboo.Accounts
  alias Naboo.Accounts.User

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end

  def validate_password(password, hash) do
    Argon2.verify_pass(password, hash)
  end

  def authenticate(email, password) do
    with {:ok, user} <- user_by_email(email) do
      check_password(user, password)
    end
  end

  def authenticate_by_uuid(uuid, password) do
    with {:ok, user} <- user_by_uuid(uuid) do
      check_password(user, password)
    end
  end

  defp user_by_email(email) do
    case Accounts.user_by_email(email) do
      user -> {:ok, user}
      nil -> {:error, :unauthenticated}
    end
  end

  defp user_by_uuid(uuid) do
    case Accounts.user_by_uuid(uuid) do
      nil -> {:error, :unauthenticated}
      user -> {:ok, user}
    end
  end

  def check_password(%User{password_hash: password_hash} = user, password) do
    case validate_password(password, password_hash) do
      true -> {:ok, user}
      _ -> {:error, :unauthenticated}
    end
  end

  def check_password(nil, password) do
    {:error, :unauthenticated}
  end
end

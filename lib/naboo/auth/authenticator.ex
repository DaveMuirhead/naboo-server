defmodule Naboo.Auth.Authenticator do
  @moduledoc """
  Basic authentication using the bcrypt password hashing function.
  """

  alias Comeonin.Bcrypt
  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  def hash_password(password), do: Bcrypt.hashpwsalt(password)
  def validate_password(password, hash), do: Bcrypt.checkpw(password, hash)

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

  def check_password(%User{hashed_password: hashed_password} = user, password) do
    case validate_password(password, hashed_password) do
      true -> {:ok, user}
      _ -> {:error, :unauthenticated}
    end
  end


end

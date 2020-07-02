defmodule Naboo.Accounts do

  alias Naboo.Accounts.Commands.{ChangeEmail, ChangePassword, RegisterUser, ResetPassword, UpdateUser}
  alias Naboo.Accounts.Projections.{User}
  alias Naboo.Accounts.Queries.{UserByEmail, UserByUuid}
  alias Naboo.Accounts.User
  alias Naboo.Repo
  alias Naboo.App

  # ################################################################################
  # Commands
  # ################################################################################

  def start_registration(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def complete_registration(%User{uuid: uuid} = user, attrs \\ %{}) do
    user
    |> User.confirm_changeset(attrs)
    |> Repo.update()
  end

  def update_user(%User{uuid: uuid} = user, attrs \\ %{}) do
    {:error, "not implemented"}
  end

  def reset_password(%{"uuid" => uuid} = attrs \\ %{}) do
    {:error, "not implemented"}
  end

  def change_password(%User{uuid: uuid} = user, %{"old_password" => old_password, "new_password" => new_password} = attrs \\ %{}) do
    {:error, "not implemented"}
  end

  def change_email(%User{uuid: uuid} = _user, %{"new_email" => new_email} = attrs \\ %{}) do
    {:error, "not implemented"}
  end


  # ################################################################################
  # Queries
  # ################################################################################

  def user_by_uuid(uuid) when is_binary(uuid) do
    uuid
    |> String.downcase()
    |> UserByUuid.new()
    |> Repo.one()
  end

  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  # ################################################################################
  # Private
  # ################################################################################

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      found -> {:ok, found}
    end
  end

end

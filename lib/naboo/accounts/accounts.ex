defmodule Naboo.Accounts do

  alias Naboo.Accounts.Queries.{UserByEmail, UserByUuid}
  alias Naboo.Accounts.User
  alias Naboo.Repo
  alias Naboo.App

  # ################################################################################
  # Commands
  # ################################################################################

  def start_registration(attrs \\ %{}) do
    %User{}
    |> User.start_registration_changeset(attrs)
    |> Repo.insert()
  end

  def complete_registration(%User{} = user, attrs \\ %{}) do
    user
    |> User.complete_registration_changeset(attrs)
    |> Repo.update()
  end

  def update_user(%User{} = user, attrs \\ %{}) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, %{password: password} = attrs \\ %{}) do
    user
    |> User.password_update_changeset(attrs)
    |> Repo.update()
  end

  def update_email(%User{} = user, %{email: email} = attrs \\ %{}) do
    user
    |> User.email_update_changeset(attrs)
    |> Repo.update()
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

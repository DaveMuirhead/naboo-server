defmodule Naboo.Accounts do

  alias Naboo.Accounts.Commands.{ChangeEmail, ChangePassword, RegisterUser, ResetPassword, UpdateUser}
  alias Naboo.Accounts.Projections.{User}
  alias Naboo.Accounts.Queries.{UserByEmail, UserByUuid}
  alias Naboo.Repo
  alias Naboo.App

  # ################################################################################
  # Commands
  # ################################################################################

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()
    command =
      Map.put(attrs, :uuid, uuid)
      |> RegisterUser.new()
      |> RegisterUser.downcase_email()
      |> RegisterUser.hash_password()
    with :ok <- App.dispatch(command, consistency: :strong) do
      get(User, uuid)
    end
  end

  def update_user(%User{uuid: uuid} = user, attrs \\ %{}) do
    command =
      attrs |> UpdateUser.new()
    with :ok <- App.dispatch(command, consistency: :strong) do
      get(User, uuid)
    end
  end

  def reset_password(%{"uuid" => uuid} = attrs \\ %{}) do
    command =
      attrs
      |> ResetPassword.new()
      |> ResetPassword.hash_password()
    with :ok <- App.dispatch(command, consistency: :strong) do
      get(User, uuid)
    end
  end

  def change_password(%User{uuid: uuid} = user, %{"old_password" => old_password, "new_password" => new_password} = attrs \\ %{}) do
    command =
      Map.merge(attrs, %{uuid: uuid, password: old_password})
      |> ChangePassword.new()
      |> ChangePassword.hash_password()
    with :ok <- App.dispatch(command, consistency: :strong) do
      get(User, uuid)
    end
  end

  def change_email(%User{uuid: uuid} = _user, %{"new_email" => new_email} = attrs \\ %{}) do
    command =
      %{"uuid" => uuid, "email" => new_email}
      |> ChangeEmail.new()
      |> ChangeEmail.downcase_email()
    with :ok <- App.dispatch(command, consistency: :strong) do
      get(User, uuid)
    end
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
      projection -> {:ok, projection}
    end
  end

end

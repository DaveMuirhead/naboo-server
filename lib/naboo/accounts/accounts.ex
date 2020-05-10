defmodule Naboo.Accounts do

  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Projections.{User}
  alias Naboo.Accounts.Queries.{UserByEmail, UserByGoogleUid}
  alias Naboo.Repo
  alias Naboo.App

  # ################################################################################
  # Commands
  # ################################################################################

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user = attrs
    |> assign(:uuid, uuid)
    |> RegisterUser.new()
    |> RegisterUser.downcase_email()
    |> RegisterUser.hash_password()

    with :ok <- App.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  # ################################################################################
  # Queries
  # ################################################################################

  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  def user_by_google_uid(uid) when is_binary(uid) do
    uid
    |> UserByGoogleUid.new()
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

  defp assign(attrs, key, value) do
    Map.put(attrs, key, value)
  end

end

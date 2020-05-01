defmodule Naboo.Accounts do

  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Projections.{User}
  alias Naboo.App
  alias Naboo.Repo


  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user = attrs
    |> assign_uuid(uuid)
    |> RegisterUser.new()

    with :ok <- App.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  defp assign_uuid(attrs, uuid) do
    Map.put(attrs, :uuid, uuid)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

end

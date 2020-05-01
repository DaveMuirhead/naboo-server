defmodule Naboo.Accounts do

  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Projections.{User}
  alias Naboo.Repo
  alias Naboo.App


  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user = attrs
    |> assign(:uuid, uuid)
    |> RegisterUser.new()

    with :ok <- App.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  defp assign(attrs, key, value) do
    Map.put(attrs, key, value)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

end

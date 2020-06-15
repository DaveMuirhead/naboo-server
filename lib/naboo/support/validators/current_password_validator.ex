defmodule Naboo.Support.Validators.CurrentPassword do
  use Vex.Validator

  alias Naboo.Auth.Authenticator

  def validate(_value, %{uuid: uuid, password: password} = context) do
    case Authenticator.authenticate_by_uuid(uuid, password) do
      {:ok, _user} -> :ok
      {:error, _} -> {:error, :unuthenticated}
    end
  end

end
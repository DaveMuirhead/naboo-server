defmodule Naboo.Support.Validators.UniqueEmail do
  use Vex.Validator

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  def validate(value, context) do
    uuid = Map.get(context, :uuid)
    case email_registered?(value) do
      true -> {:error, "This email is already registered."}
      false -> :ok
    end
  end

  def email_registered?(email) do
    case Accounts.user_by_email(email) do
      %User{email: ^email} -> true
      nil -> false
    end
  end

end

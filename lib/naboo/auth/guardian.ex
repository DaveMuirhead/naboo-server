defmodule Naboo.Auth.Guardian do
  @moduledoc """
    Used by Guardian to serialize a JWT token
  """

  use Guardian, otp_app: :naboo

  alias Naboo.Accounts
  alias Naboo.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, user.uuid}
  end

  def subject_for_token(_resource, _claims) do
    {:error, "Unknown resource type"}
  end

  def resource_from_claims(%{"sub" => uuid}) do
    {:ok, Accounts.user_by_uuid(uuid)}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_claims) do
    {:error, "Unknown resource type"}
  end

end

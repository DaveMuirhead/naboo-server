defmodule Naboo.Auth.Guardian do
  @moduledoc """
    Used by Guardian to serialize a JWT token
  """

  use Guardian, otp_app: :naboo

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  def subject_for_token(%User{} = user, _claims), do: {:ok, "User:#{user.uuid}"}
  def subject_for_token(_resource, _claims), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => "User:" <> uuid}), do: {:ok, Accounts.user_by_uuid(uuid)}
  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end

defmodule NabooWeb.JWT do
  @moduledoc """
  JSON Web Token helper functions, using Guardian
  """

  alias Naboo.Auth.Guardian

  def generate_jwt(resource) do
    case Guardian.encode_and_sign(resource, %{}, token_type: :token) do
      {:ok, jwt, _full_claims} -> {:ok, jwt}
    end
  end

end

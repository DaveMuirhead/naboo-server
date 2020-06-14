defmodule Naboo.Accounts.Commands.ResetPassword do
  defstruct uuid: "",
            password: "",
            hashed_password: ""

  use ExConstructor
  use Vex.Struct

  alias Naboo.Accounts.Commands.ResetPassword
  alias Naboo.Auth.Authenticator

  validates(:uuid, uuid: true)
  validates(:hashed_password, presence: true, string: true)

  def hash_password(%ResetPassword{password: password} = reset_password) do
    %ResetPassword{reset_password| password: nil, hashed_password: Authenticator.hash_password(password)}
  end
end
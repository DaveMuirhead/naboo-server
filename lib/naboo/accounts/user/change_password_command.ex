defmodule Naboo.Accounts.Commands.ChangePassword do
  defstruct uuid: "",
            password: "",
            new_password: "",
            new_hashed_password: ""

  use ExConstructor
  use Vex.Struct

  alias Naboo.Accounts.Commands.ChangePassword
  alias Naboo.Auth.Authenticator
  alias Naboo.Support.Validators.{CurrentPassword, StrongPassword}

  validates(:uuid, uuid: true)
  validates(:password, presence: true, by: &CurrentPassword.validate/2)
  validates(:new_password, presence: true, by: &StrongPassword.validate/2)
  validates(:new_hashed_password, presence: true, string: true)

  def hash_password(%ChangePassword{new_password: new_password} = command) do
    %ChangePassword{command | new_hashed_password: Authenticator.hash_password(new_password)}
  end
end
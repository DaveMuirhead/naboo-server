defmodule Naboo.Accounts.Commands.RegisterUser do
  defstruct [
    :uuid,
    :email,
    :password,
    :hashed_password,
  ]

  use ExConstructor
end

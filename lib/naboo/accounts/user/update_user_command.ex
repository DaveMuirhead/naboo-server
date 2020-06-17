defmodule Naboo.Accounts.Commands.UpdateUser do
  defstruct [
    active: false,
    email_verified: false,
    full_name: nil,
    picture: nil,
    nickname: nil,
    uuid: nil
  ]

  use ExConstructor
  use Vex.Struct

end

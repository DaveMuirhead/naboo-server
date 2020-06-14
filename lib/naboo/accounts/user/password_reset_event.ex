defmodule Naboo.Accounts.Events.UserPasswordReset do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :hashed_password
  ]
end
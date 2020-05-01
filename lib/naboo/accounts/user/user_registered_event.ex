defmodule Naboo.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :email,
    :hashed_password
  ]
end

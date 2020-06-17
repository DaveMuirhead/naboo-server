defmodule Naboo.Accounts.Events.UserEmailChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :email
  ]
end


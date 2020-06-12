defmodule Naboo.Accounts.Events.UserEmailVerifiedChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :email_verified
  ]
end
defmodule Naboo.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [
    :account_type,
    :email,
    :full_name,
    :hashed_password,
    :picture,
    :nickname,
    :uuid
  ]
end

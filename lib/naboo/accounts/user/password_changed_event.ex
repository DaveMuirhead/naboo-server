defmodule Naboo.Accounts.Events.UserPasswordChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :hashed_password
  ]
  end
defmodule Naboo.Accounts.Events.UserNicknameChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :nickname
  ]
end
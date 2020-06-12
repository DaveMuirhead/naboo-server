defmodule Naboo.Accounts.Events.UserActiveChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :active
  ]
end
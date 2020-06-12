defmodule Naboo.Accounts.Events.UserFullNameChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :full_name
  ]
end
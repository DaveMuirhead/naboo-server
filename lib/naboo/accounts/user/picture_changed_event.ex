defmodule Naboo.Accounts.Events.UserPictureChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :picture
  ]
end
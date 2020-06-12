defmodule Naboo.Accounts.Events.UserImageUrlChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :image_url
  ]
end
defmodule Naboo.Accounts.Events.UserUpdated do
  @derive Jason.Encoder
  defstruct [
    :active,
    :email_verified,
    :full_name,
    :image_url,
    :nickname,
    :uuid
  ]
end

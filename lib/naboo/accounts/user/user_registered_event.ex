defmodule Naboo.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [
    :email,
    :first_name,
    :google_uid,
    :hashed_password,
    :image_url,
    :last_name,
    :uuid,
  ]
end

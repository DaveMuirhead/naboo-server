defmodule Naboo.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [
    :account_type,
    :email,
    :email_verified,
    :full_name,
    :google_uid,
    :hashed_password,
    :image_url,
    :nickname,
    :uuid,
  ]
end

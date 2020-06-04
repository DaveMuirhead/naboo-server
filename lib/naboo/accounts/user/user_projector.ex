defmodule Naboo.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
      application: Naboo.App,
      name: "Accounts.Projectors.User",
      consistency: :strong

  alias Naboo.Accounts.Events.{UserRegistered}
  alias Naboo.Accounts.Projections.{User}

  project(%UserRegistered{} = event, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: event.uuid,
      account_type: event.account_type,
      email: event.email,
      full_name: event.full_name,
      google_uid: event.google_uid,
      hashed_password: event.hashed_password,
      image_url: event.image_url,
      nickname: event.nickname
    })
  end)

end
defmodule Naboo.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
      application: Naboo.App,
      name: "Accounts.Projectors.User",
      consistency: :strong

  alias Naboo.Accounts.Events.{UserRegistered}
  alias Naboo.Accounts.Projections.{User}

  project(%UserRegistered{} = registered, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.uuid,
      email: registered.email,
      full_name: registered.full_name,
      google_uid: registered.google_uid,
      hashed_password: registered.hashed_password,
      image_url: registered.image_url,
      nickname: registered.nickname
    })
  end)

end
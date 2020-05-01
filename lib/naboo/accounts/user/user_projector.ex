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
      hashed_password: registered.hashed_password
    })
  end)

end
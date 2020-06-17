defmodule Naboo.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
      application: Naboo.App,
      name: "Accounts.Projectors.User",
      consistency: :strong

  alias Naboo.Accounts.Events.{
    UserActiveChanged,
    UserEmailChanged,
    UserEmailVerifiedChanged,
    UserFullNameChanged,
    UserPictureChanged,
    UserNicknameChanged,
    UserPasswordChanged,
    UserPasswordReset,
    UserRegistered,
    }
  alias Naboo.Accounts.Projections.{User}

  project(%UserRegistered{} = event, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      account_type: event.account_type,
      active: false,
      email: event.email,
      email_verified: false,
      full_name: event.full_name,
      hashed_password: event.hashed_password,
      picture: event.picture,
      nickname: event.nickname,
      uuid: event.uuid
    })
  end)

  project(
    %UserActiveChanged{uuid: uuid, active: active},
    fn multi -> update_user(multi, uuid, active: active) end
  )

  project(
    %UserEmailVerifiedChanged{uuid: uuid, email_verified: email_verified},
    fn multi -> update_user(multi, uuid, email_verified: email_verified) end
  )

  project(
    %UserFullNameChanged{uuid: uuid, full_name: full_name},
    fn multi -> update_user(multi, uuid, full_name: full_name) end
  )

  project(
    %UserPictureChanged{uuid: uuid, picture: picture},
    fn multi -> update_user(multi, uuid, picture: picture) end
  )

  project(
    %UserNicknameChanged{uuid: uuid, nickname: nickname},
    fn multi -> update_user(multi, uuid, nickname: nickname) end
  )

  project(%UserPasswordReset{uuid: uuid, hashed_password: hashed_password}, fn multi ->
    update_user(multi, uuid, hashed_password: hashed_password)
  end)

  project(%UserPasswordChanged{uuid: uuid, hashed_password: hashed_password}, fn multi ->
    update_user(multi, uuid, hashed_password: hashed_password)
  end)

  project(%UserEmailChanged{uuid: uuid, email: email}, fn multi ->
    update_user(multi, uuid, email: email)
  end)


  defp update_user(multi, uuid, changes) do
    Ecto.Multi.update_all(multi, :user, user_query(uuid), set: changes)
  end

  defp user_query(uuid) do
    from(u in User, where: u.uuid == ^uuid)
  end

end
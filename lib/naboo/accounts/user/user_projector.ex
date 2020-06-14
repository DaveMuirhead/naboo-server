defmodule Naboo.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
      application: Naboo.App,
      name: "Accounts.Projectors.User",
      consistency: :strong

  alias Naboo.Accounts.Events.{
    UserActiveChanged,
    UserEmailVerifiedChanged,
    UserFullNameChanged,
    UserImageUrlChanged,
    UserNicknameChanged,
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
      image_url: event.image_url,
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
    %UserImageUrlChanged{uuid: uuid, image_url: image_url},
    fn multi -> update_user(multi, uuid, image_url: image_url) end
  )

  project(
    %UserNicknameChanged{uuid: uuid, nickname: nickname},
    fn multi -> update_user(multi, uuid, nickname: nickname) end
  )

  project(%UserPasswordReset{uuid: uuid, hashed_password: hashed_password}, fn multi ->
    update_user(multi, uuid, hashed_password: hashed_password)
  end)

  defp update_user(multi, user_uuid, changes) do
    Ecto.Multi.update_all(multi, :user, user_query(user_uuid), set: changes)
  end

  defp user_query(user_uuid) do
    from(u in User, where: u.uuid == ^user_uuid)
  end

end
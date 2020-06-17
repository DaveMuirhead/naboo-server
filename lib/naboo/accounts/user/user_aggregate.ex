defmodule Naboo.Accounts.Aggregates.User do
  defstruct [
    :account_type, #:provider or :seeker
    :active,
    :email,
    :email_verified,
    :full_name,
    :hashed_password,
    :picture,
    :nickname,
    :password,
    :uuid,
  ]

  alias Naboo.Accounts.Aggregates.{User}
  alias Naboo.Accounts.Commands.{
    ChangeEmail,
    ChangePassword,
    RegisterUser,
    ResetPassword,
    UpdateUser,
  }
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

  # ################################################################################
  # Execute Commands
  # ################################################################################

  def execute(%User{uuid: nil}, %RegisterUser{} = command) do
    %UserRegistered{
      account_type: command.account_type,
      email: command.email,
      full_name: command.full_name,
      hashed_password: command.hashed_password,
      picture: command.picture,
      nickname: command.nickname,
      uuid: command.uuid
    }
  end

  def execute(%User{} = user, %UpdateUser{} = command) do
    Enum.reduce(
      [
        &active_changed/2,
        &email_verified_changed/2,
        &full_name_changed/2,
        &picture_changed/2,
        &nickname_changed/2,
      ],
      [],
      fn (change, events) ->
        case change.(user, command) do
          nil -> events
          event -> [event | events]
        end
      end)
  end

  def execute(%User{} = _user, %ResetPassword{} = command) do
    %UserPasswordReset{
      uuid: command.uuid,
      hashed_password: command.hashed_password
    }
  end

  def execute(%User{} = _user, %ChangePassword{} = command) do
    %UserPasswordChanged{
      uuid: command.uuid,
      hashed_password: command.new_hashed_password
    }
  end

  def execute(%User{} = _user, %ChangeEmail{} = command) do
    %UserEmailChanged{
      uuid: command.uuid,
      email: command.email
    }
  end


  # ################################################################################
  # Apply Events
  # ################################################################################

  def apply(%User{} = user, %UserRegistered{} = event) do
    %User{user |
      account_type: event.account_type,
      email: event.email,
      full_name: event.full_name,
      hashed_password: event.hashed_password,
      picture: event.picture,
      nickname: event.nickname,
      uuid: event.uuid
    }
  end

  def apply(%User{} = user, %UserActiveChanged{active: active}) do
    %User{user | active: active}
  end

  def apply(%User{} = user, %UserEmailVerifiedChanged{email_verified: email_verified}) do
    %User{user | email_verified: email_verified}
  end

  def apply(%User{} = user, %UserFullNameChanged{full_name: full_name}) do
    %User{user | full_name: full_name}
  end

  def apply(%User{} = user, %UserPictureChanged{picture: picture}) do
    %User{user | picture: picture}
  end

  def apply(%User{} = user, %UserNicknameChanged{nickname: nickname}) do
    %User{user | nickname: nickname}
  end

  def apply(%User{} = user, %UserPasswordReset{hashed_password: hashed_password}) do
    %User{user | hashed_password: hashed_password}
  end

  def apply(%User{} = user, %UserPasswordChanged{hashed_password: hashed_password}) do
    %User{user | hashed_password: hashed_password}
  end

  def apply(%User{} = user, %UserEmailChanged{email: email}) do
    %User{user | email: email}
  end


  # ################################################################################
  # Helpers
  # ################################################################################

  defp active_changed(%User{}, %UpdateUser{active: nil}), do: nil
  defp active_changed(%User{active: active}, %UpdateUser{active: active}), do: nil
  defp active_changed(%User{uuid: uuid}, %UpdateUser{active: active}) do
    %UserActiveChanged{
      uuid: uuid,
      active: active
    }
  end

  defp email_verified_changed(%User{}, %UpdateUser{email_verified: nil}), do: nil
  defp email_verified_changed(%User{email_verified: verified}, %UpdateUser{email_verified: verified}), do: nil
  defp email_verified_changed(%User{uuid: uuid}, %UpdateUser{email_verified: verified}) do
    %UserEmailVerifiedChanged{
      uuid: uuid,
      email_verified: verified
    }
  end

  defp full_name_changed(%User{}, %UpdateUser{full_name: ""}), do: nil
  defp full_name_changed(%User{full_name: full_name}, %UpdateUser{full_name: full_name}), do: nil
  defp full_name_changed(%User{uuid: uuid}, %UpdateUser{full_name: full_name}) do
    %UserFullNameChanged{
      uuid: uuid,
      full_name: full_name
    }
  end

  defp picture_changed(%User{}, %UpdateUser{picture: ""}), do: nil
  defp picture_changed(%User{picture: picture}, %UpdateUser{picture: picture}), do: nil
  defp picture_changed(%User{uuid: uuid}, %UpdateUser{picture: picture}) do
    %UserPictureChanged{
      uuid: uuid,
      picture: picture
    }
  end

  defp nickname_changed(%User{}, %UpdateUser{nickname: nil}), do: nil
  defp nickname_changed(%User{nickname: nickname}, %UpdateUser{nickname: nickname}), do: nil
  defp nickname_changed(%User{uuid: uuid}, %UpdateUser{nickname: nickname}) do
    %UserNicknameChanged{
      uuid: uuid,
      nickname: nickname
    }
  end


end

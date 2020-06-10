defmodule Naboo.Accounts.Aggregates.User do
  defstruct [
    :account_type, #:provider or :seeker
    :email,
    :email_verified,
    :full_name,
    :google_uid,
    :hashed_password,
    :image_url,
    :nickname,
    :password,
    :uuid,
  ]

  alias Naboo.Accounts.Aggregates.{User}
  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Events.{UserRegistered}

  # ################################################################################
  # Command Execution
  # ################################################################################

  def execute(%User{uuid: nil}, %RegisterUser{} = command) do
    %UserRegistered{
      account_type: command.account_type,
      email: command.email,
      email_verified: command.email_verified,
      full_name: command.full_name,
      google_uid: command.google_uid,
      hashed_password: command.hashed_password,
      image_url: command.image_url,
      nickname: command.nickname,
      uuid: command.uuid,
    }
  end

  # ################################################################################
  # Event Application
  # ################################################################################

  def apply(%User{} = user, %UserRegistered{} = event) do
    %User{user |
      account_type: event.account_type,
      email: event.email,
      email_verified: event.email_verified,
      full_name: event.full_name,
      google_uid: event.google_uid,
      hashed_password: event.hashed_password,
      image_url: event.image_url,
      nickname: event.nickname,
      uuid: event.uuid,
    }
    end

end

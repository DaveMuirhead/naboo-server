defmodule Naboo.Accounts.Aggregates.User do
  defstruct [
    :email,
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

  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      email: register.email,
      full_name: register.full_name,
      google_uid: register.google_uid,
      hashed_password: register.hashed_password,
      image_url: register.image_url,
      nickname: register.nickname,
      uuid: register.uuid,
    }
  end

  # ################################################################################
  # Event Application
  # ################################################################################

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{user |
      email: registered.email,
      full_name: registered.full_name,
      google_uid: registered.google_uid,
      hashed_password: registered.hashed_password,
      image_url: registered.image_url,
      nickname: registered.nickname,
      uuid: registered.uuid,
    }
    end

end

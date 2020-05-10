defmodule Naboo.Accounts.Aggregates.User do
  defstruct [
    :email,
    :first_name,
    :google_uid,
    :hashed_password,
    :image_url,
    :last_name,
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
      first_name: register.first_name,
      google_uid: register.google_uid,
      hashed_password: register.hashed_password,
      image_url: register.image_url,
      last_name: register.last_name,
      uuid: register.uuid,
    }
  end

  # ################################################################################
  # Event Application
  # ################################################################################

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{user |
      email: registered.email,
      first_name: registered.first_name,
      google_uid: registered.google_uid,
      hashed_password: registered.hashed_password,
      image_url: registered.image_url,
      last_name: registered.last_name,
      uuid: registered.uuid,
    }
    end

end

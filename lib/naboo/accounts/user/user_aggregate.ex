defmodule Naboo.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :email,
    :first_name,
    :hashed_password,
    :last_name
  ]

  alias Naboo.Accounts.Aggregates.{User}
  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Events.{UserRegistered}

  # ################################################################################
  # Command Execution
  # ################################################################################

  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      uuid: register.uuid,
      email: register.email,
      hashed_password: register.hashed_password,
    }
  end

  # ################################################################################
  # Event Application
  # ################################################################################

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{user |
      uuid: registered.uuid,
      email: registered.email,
      hashed_password: registered.hashed_password,
    }
    end

end

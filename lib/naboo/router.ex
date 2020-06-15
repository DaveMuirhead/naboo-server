defmodule Naboo.Router do
  use Commanded.Commands.Router

  alias Naboo.Accounts.Aggregates.User
  alias Naboo.Accounts.Commands.{ChangePassword, RegisterUser, ResetPassword, UpdateUser}
  alias Naboo.Support.Middleware.{Validate, Uniqueness}

  middleware Validate
  middleware Uniqueness

  dispatch [ChangePassword, RegisterUser, ResetPassword, UpdateUser], to: User, identity: :uuid
end

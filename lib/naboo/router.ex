defmodule Naboo.Router do
  use Commanded.Commands.Router

  alias Naboo.Accounts.Aggregates.User
  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Support.Middleware.{Validate, Uniqueness}

  middleware Validate
  middleware Uniqueness

  dispatch [RegisterUser], to: User, identity: :uuid
end

defmodule Naboo.Router do
  use Commanded.Commands.Router

  alias Naboo.Accounts.Aggregates.User
  alias Naboo.Accounts.Commands.RegisterUser

  dispatch [RegisterUser], to: User, identity: :uuid
end

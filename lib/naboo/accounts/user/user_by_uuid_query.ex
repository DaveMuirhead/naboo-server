defmodule Naboo.Accounts.Queries.UserByUuid do
  import Ecto.Query

  alias Naboo.Accounts.User

  def new(uuid) do
    from u in User,
      where: u.uuid == ^uuid
  end

end

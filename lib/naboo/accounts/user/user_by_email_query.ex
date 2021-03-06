defmodule Naboo.Accounts.Queries.UserByEmail do
  import Ecto.Query

  alias Naboo.Accounts.User

  def new(email) do
    from u in User,
      where: u.email == ^email
  end

end

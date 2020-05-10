defmodule Naboo.Accounts.Queries.UserByGoogleUid do
  import Ecto.Query

  alias Naboo.Accounts.Projections.User

  def new(google_uid) do
    from u in User,
      where: u.google_uid == ^google_uid
  end

end

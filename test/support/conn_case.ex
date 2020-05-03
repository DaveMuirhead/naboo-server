defmodule NabooWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use NabooWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import NabooWeb.ConnCase

      alias NabooWeb.Router.Helpers, as: Routes

      import Naboo.Factory

      # The default endpoint for testing
      @endpoint NabooWeb.Endpoint
    end
  end

#  This is the normal Ecto Sandbox approach; see also test.exs
#  setup tags do
#    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Naboo.Repo)
#
#    unless tags[:async] do
#      Ecto.Adapters.SQL.Sandbox.mode(Naboo.Repo, {:shared, self()})
#    end
#
#    {:ok, conn: Phoenix.ConnTest.build_conn()}
#  end

  # Ben Smith rolled his own database reset approach with the Storage module
  setup tags do
    Naboo.Storage.reset!()

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end

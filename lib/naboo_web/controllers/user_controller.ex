defmodule NabooWeb.UserController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias NabooWeb.Avatar
  alias NabooWeb.Mailer
  alias NabooWeb.Token
  alias NabooWeb.Router.Helpers, as: Routes

  action_fallback NabooWeb.FallbackController

  # ############################################################
  # Query User
  # ############################################################

  # GET /users/current
  def current(conn, _params) do
    with user = Guardian.Plug.current_resource(conn),
         jwt = Guardian.Plug.current_token(conn)
    do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user, jwt: jwt)
    end
  end

  # GET /users/:uuid
  def profile(conn, params) do
    uuid = params["uuid"]
    with user <- Accounts.user_by_uuid(uuid) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  # ############################################################
  # Update User
  # ############################################################

  # PATCH /users/:uuid
  def update(conn, params) do
    IO.puts("params=")
    IO.inspect(params)
    {:error, :not_implemented}
  end

end
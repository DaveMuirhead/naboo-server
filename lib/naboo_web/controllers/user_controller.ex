defmodule NabooWeb.UserController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  action_fallback NabooWeb.FallbackController

  def show(conn, %{"uuid" => uuid}) do
    case Accounts.user_by_uuid(uuid) do
      user_with_uuid ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user_with_uuid)
      nil ->
        conn
        |> put_status(:not_found)
        |> render("empty.json", user: %{})
    end
  end

  def current(conn, _params) do
    with user = Guardian.Plug.current_resource(conn),
         jwt = Guardian.Plug.current_token(conn)
      do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user, jwt: jwt)
    end
  end

end

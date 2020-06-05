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

  @doc """
  Find user by email, report :found or :not_found with empty body.
  A JSON object of the following structure is expected:
  {
    "email": ""
  }
  """
  def validate_email_exists(conn, params) do
    email = Map.get(params, "email")
    case Accounts.user_by_email(email) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("empty.json", user: %{})
      _user ->
        conn
        |> put_status(:ok)
        |> render("empty.json", user: %{})
    end
  end

end

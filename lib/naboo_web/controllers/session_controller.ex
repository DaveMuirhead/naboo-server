defmodule NabooWeb.SessionController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Authenticator
  alias Naboo.Auth.Guardian
  alias Naboo.Auth.Session

  action_fallback NabooWeb.FallbackController

  # POST /sessions
  def sign_in(conn,  %{"email" => email, "password" => password}) do
    Authenticator.authenticate(email, password)
    |> maybe_admit_user(conn)
  end

  # DELETE /sessions
  def sign_out(conn, params) do
    conn
    |> Session.del_token_cookie()
    |> Guardian.Plug.sign_out()
    |> send_resp(200, "")
  end

  # ############################################################
  # Support
  # ############################################################

  defp maybe_admit_user({:ok, user}, conn) do
    case user.active do
      true ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> Session.put_token_cookie()
        |> put_resp_header("Location", Routes.user_path(NabooWeb.Endpoint, :profile, user))
        |> render("session.json", user: user)
      false ->
        conn
        |> put_status(:forbidden)
        |> render("inactive.json")
    end
  end

  defp maybe_admit_user({:error, message}, conn) do
    conn
    |> put_status(:unauthorized)
    |> render(:unauthorized)
  end

end

defmodule NabooWeb.SessionController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Authenticator
  alias Naboo.Auth.Guardian

  action_fallback NabooWeb.FallbackController

  # POST /sessions
  def sign_in(conn,  %{"email" => email, "password" => password}) do
    Authenticator.authenticate(email, password)
    |> maybe_admit_user(conn)
  end

  # DELETE /sessions
  def sign_out(conn, params) do
    conn
    |> del_token_cookie()
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> render("empty.json")
  end

  # ############################################################
  # Support
  # ############################################################

  defp maybe_admit_user({:ok, user}, conn) do
    case user.active do
      true ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_token_cookie(user)
        |> put_resp_header("Location", Routes.user_path(NabooWeb.Endpoint, :profile, user))
        |> render("session.json")
      false ->
        conn
        |> put_status(:forbidden)
        |> render("inactive.json")
    end
  end

  defp maybe_admit_user({:error, message}, conn) do
    conn
    |> put_status(:unauthorized)
    |> render(:"401")
  end

  defp put_token_cookie(conn, user) do
    token = Guardian.Plug.current_token(conn)
    conn
    |> put_resp_cookie(
        Guardian.access_token_cookie_key(), # key
        token,                              # value
        token_cookie_options()              # options
      )
  end

  defp del_token_cookie(conn) do
    conn
    |> delete_resp_cookie(
         Guardian.access_token_cookie_key(),
         token_cookie_options()
       )
  end

  defp token_cookie_options()  do
    [
      max_age: (7 * 24 * 60 * 60),        # valid for 7 days
      http_only: true,                    # cookie not accessible outside of HTTP
      #secure: true,                       # cookie may only sent over HTTPS
      encrypt: true                       # encrypt the cookie
    ]
  end

end

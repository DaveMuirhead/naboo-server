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

  defp maybe_admit_user({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> store_token_securely(user)
    |> render("session.json")
  end

  defp store_token_securely(conn, user) do
    token = Guardian.Plug.current_token(conn)
    conn
    |> put_resp_cookie(
        Guardian.access_token_cookie_key(), # key
        token,                              # value
        max_age: (7 * 24 * 60 * 60),        # valid for 7 days
        http_only: true,                    # cookie not accessible outside of HTTP
        #secure: true,                       # cookie may only sent over HTTPS
        encrypt: true                       # encrypt the cookie
      )
  end

  defp maybe_admit_user({:error, message}, conn) do
    conn
    |> put_status(:unauthorized)
#    |> put_view(NabooWeb.ErrorView)
    |> render(NabooWeb.ErrorView, :"401")
  end

  # DELETE /sessions
  def sign_out(conn, params) do
    conn
    |> put_status(:ok)
    |> render(NabooWeb.UserView, "empty.json")
  end

end

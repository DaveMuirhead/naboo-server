defmodule Naboo.Auth.Session do

  import Plug.Conn
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Session

  def access_token_cookie_key, do: "naboo_access"

  def put_token_cookie(conn) do
    token = Guardian.Plug.current_token(conn)
    conn
    |> put_resp_cookie(
         Session.access_token_cookie_key(), # key
         token,                             # value
         token_cookie_options()             # options
       )
  end

  def del_token_cookie(conn) do
    conn
    |> delete_resp_cookie(
         Session.access_token_cookie_key(),
         token_cookie_options()
       )
  end

  def token_cookie_options()  do
    [
      max_age: (7 * 24 * 60 * 60),        # valid for 7 days
      http_only: true,                    # cookie not accessible outside of HTTP
      #secure: true,                       # cookie may only sent over HTTPS
      encrypt: true                       # encrypt the cookie
    ]
  end

end
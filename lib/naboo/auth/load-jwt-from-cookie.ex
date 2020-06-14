defmodule Naboo.Auth.LoadJwtFromCookie do
  import Plug.Conn

  alias Naboo.Auth.Guardian
  alias Naboo.Auth.Session

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> fetch_cookies(encrypted: [Session.access_token_cookie_key()])
    |> add_auth_header()
  end

  defp add_auth_header(conn) do
    case conn.cookies[Session.access_token_cookie_key()] do
      nil -> conn
      jwt ->
        conn
        |> put_req_header("authorization", "Bearer " <> jwt)
    end
  end

end

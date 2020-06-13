defmodule Naboo.Auth.LoadJwtFromCookie do
  import Plug.Conn

  alias Naboo.Auth.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> fetch_cookies(encrypted: [Guardian.access_token_cookie_key()])
    |> add_auth_header()
  end

  defp add_auth_header(conn) do
    case conn.cookies[Guardian.access_token_cookie_key()] do
      nil -> conn
      jwt ->
        conn
        |> put_req_header("authorization", "Bearer " <> jwt)
    end
  end

end

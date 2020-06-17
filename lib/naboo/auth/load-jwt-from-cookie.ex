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
    case Map.get(conn.cookies, Session.access_token_cookie_key()) do
      nil ->
        IO.puts("LoadJwtFromCookie.add_auth_header did NOT find JWT cookie")
        conn
      jwt ->
        IO.puts("LoadJwtFromCookie.add_auth_header DID find JWT cookie")
        conn
        |> put_req_header("authorization", "Bearer " <> jwt)
    end
  end

end

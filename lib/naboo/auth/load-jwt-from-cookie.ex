defmodule Naboo.Auth.LoadJwtFromCookie do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> fetch_cookies(encrypted: ["naboo_access"])
    |> add_auth_header()
  end

  defp add_auth_header(conn) do
    jwt = conn.cookies["naboo_access"]
    conn
    |> put_req_header("authorization", "Bearer " <> jwt)
  end

end

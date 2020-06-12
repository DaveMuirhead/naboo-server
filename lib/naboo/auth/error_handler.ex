defmodule Naboo.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, opts) do
    IO.inspect(conn)
    IO.puts("ErrorHandler.auth_error - type=#{type} reason=#{reason} opts=")
    IO.inspect(opts)
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end

end

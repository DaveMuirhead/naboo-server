defmodule Naboo.Auth.VerifyActive do
  import Plug.Conn

  alias Guardian.Plug.Pipeline
  alias Naboo.Auth.Guardian

  def init(opts), do: opts

  def call(conn, opts) do
    user = Guardian.Plug.current_resource(conn)
    active_or_halt(conn, opts, user)
  end

  defp active_or_halt(conn, opts, nil) do
    dont_continue(conn, opts)
  end

  defp active_or_halt(conn, opts, user) do
    case user.active do
      true -> do_continue(conn, opts)
      false -> dont_continue(conn, opts)
    end
  end

  defp do_continue(conn, _opts) do
    conn
  end

  defp dont_continue(conn, opts) do
    conn
    |> Pipeline.fetch_error_handler!(opts)
    |> apply(:auth_error, [conn, {:user_inactive, "user account is inactive"}, opts])
    |> halt()
  end

end

defmodule Naboo.Auth.VerifyActive do
  import Plug.Conn

  alias Guardian.Plug.Pipeline
  alias Naboo.Auth.Guardian

  def init(opts), do: opts

  def call(conn, opts) do
    with user <- Guardian.Plug.current_resource(conn) do
      case user.active do
        true ->
          conn
        false ->
          conn
          |> Pipeline.fetch_error_handler!(opts)
          |> apply(:auth_error, [conn, {:user_inactive, "user account is inactive"}, opts])
          |> halt()
      end
    end
  end

end

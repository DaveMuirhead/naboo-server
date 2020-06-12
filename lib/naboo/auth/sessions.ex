defmodule NabooWeb.Auth.Session do

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Guardian
  alias Plug.Conn

  def user_for_session(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def get_current_user(conn) do
    Conn.get_session(conn, :current_user)
  end

  def put_current_user(conn, %User{} = user) do
    Conn.put_session(conn, :current_user, %{uuid: user.uuid, email: user.email, token: user.token})
  end

  def del_current_user(conn) do
    Conn.delete_session(conn, :current_user)
  end

  def get_session_token(conn) do
    Conn.get_session(conn, :session_token)
  end

  def put_session_token(conn, token) do
    Conn.put_session(conn, :session_token, token)
  end

  def del_session_token(conn) do
    Conn.delete_session(conn, :session_token)
  end

end

defmodule NabooWeb.SessionController do
  use NabooWeb, :controller

  alias Naboo.Auth.Authenticator

  action_fallback NabooWeb.FallbackController

  # POST /sessions
  def sign_in(conn, params) do
    conn
    |> put_status(:not_implemented)
    |> render(NabooWeb.ErrorView, :not_found)
  end

  # DELETE /sessions
  def sign_out(conn, params) do
    conn
    |> put_status(:not_implemented)
    |> render(NabooWeb.ErrorView, :not_found)
  end

end

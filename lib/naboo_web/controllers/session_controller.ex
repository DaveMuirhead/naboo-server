defmodule NabooWeb.SessionController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Auth
  alias Naboo.Accounts.Projections.User

  action_fallback NabooWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate(email, password) do
      {:ok, user} ->
        conn = conn
        |> Guardian.Plug.sign_in(Naboo.Auth.Guardian, user)
        token = Guardian.Plug.current_token(conn)
        render(conn, "signed_in.json", user: user, token: token)
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end

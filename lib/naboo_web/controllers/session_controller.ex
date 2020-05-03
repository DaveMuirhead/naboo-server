defmodule NabooWeb.SessionController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  action_fallback NabooWeb.FallbackController

  def sign_in(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> render("signed_in.json")
    end
  end
end

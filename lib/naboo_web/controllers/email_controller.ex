defmodule NabooWeb.EmailController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias NabooWeb.Mailer
  alias NabooWeb.Token
  alias NabooWeb.Router.Helpers, as: Routes

  action_fallback NabooWeb.FallbackController

  # ############################################################
  # Query
  # ############################################################

  # GET /users/email/:email
  def exists(conn, params) do
    email = params["email"]
    case Accounts.user_by_email(email) do
      %User{} = user ->
        conn
        |> put_status(:ok)
        |> put_view(NabooWeb.UserView)
        |> render("empty.json")
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(NabooWeb.UserView)
        |> render("empty.json")
    end
  end

end

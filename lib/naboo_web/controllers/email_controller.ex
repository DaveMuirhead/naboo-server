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
        |> send_resp(200, "")
      nil ->
        conn
        |> send_resp(401, "")
    end
  end

end

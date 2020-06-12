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
    # 200 OK if registered or 404 Not Found if not registered
    conn
    |> put_status(:not_implemented)
    |> render(NabooWeb.ErrorView, :not_found)
  end

end

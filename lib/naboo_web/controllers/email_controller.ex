defmodule NabooWeb.EmailController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.VerificationCode
  alias NabooWeb.Email
  alias NabooWeb.Mailer
  alias NabooWeb.Mailer
  alias NabooWeb.Router.Helpers, as: Routes
  alias NabooWeb.Token

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

  # POST /users/:uuid/email-changes
  #
  # Request
  #  {"new_email":""}
  #
  # Success Response
  #  202 (Accepted) with no content
  #  Sends email verification request to new email address
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  #  422 (Unprocessable Entity) on validation error
  def start_email_change(conn, %{"new_email" => new_email} = params) do
    with user <- Guardian.Plug.current_resource(conn) do
      code = VerificationCode.next()
      conn
      |> request_email_verification(user, new_email, code)
      |> assign_verification_token(user, new_email, code)
      |> assign(:new_email, new_email)
      |> put_status(:accepted)
      |> render("email_change.json")
    end
  end

  # PATCH /users/:uuid/email-changes
  #
  # Request
  #  {"new_email":"", "secret":"", "code":""}
  #
  # Success Response
  #  200 (OK) with updated user structure
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  def complete_email_change(conn, %{"new_email" => new_email, "secret" => token, "code" => code} = params) do
    with user <- Guardian.Plug.current_resource(conn) do
      token_data = build_token_data(user.uuid, new_email, code)
      with {:ok, :matched} <- Token.check_verification_token(token, token_data),
           {:ok, %User{} = user} <- Accounts.change_email(user, params)
      do
        conn
        |> put_status(:ok)
        |> put_view(NabooWeb.UserView)
        |> render("user.json", user: user)
      end
    end
  end


  # ############################################################
  # Utilities
  # ############################################################

  defp request_email_verification(conn, user, new_email, code) do
    Email.confirm_email_change(conn, user, new_email, code)
    |> Mailer.deliver_later()
    conn
  end

  # store a token encoding the verification code in the user session
  defp assign_verification_token(conn, user, new_email, code) do
    token_data = build_token_data(user.uuid, new_email, Integer.to_string(code))
    token = Token.generate_verification_token(token_data)
    conn
    |> assign(:secret, token)
  end

  defp build_token_data(uuid, email, code) do
    uuid <> ":" <> email <> ":" <> code
  end

end

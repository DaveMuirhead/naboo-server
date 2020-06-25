defmodule NabooWeb.RegistrationController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Guardian
  alias Naboo.Auth.Session
  alias Naboo.Auth.VerificationCode
  alias NabooWeb.Email
  alias NabooWeb.Mailer
  alias NabooWeb.Router.Helpers, as: Routes
  alias NabooWeb.Token

  action_fallback NabooWeb.FallbackController

  # POST /registrations
  # Creates user (inactive, email not verified), sends registration
  # confirmation email, returns email, token and uuid
  #
  # Request
  # {
  #	"account_type": "seeker",
  #	"email": "dave@movedbymercy.com",
  #	"full_name": "Dave Muirhead",
  #	"password": "wiu#U12$$11"
  # }
  #
  # Success Response
  # Status 201 (Created)
  # {
  #  "email": "dave@brsg.io",
  #  "secret": "QTEyOEdDTQ.O5seRh15OJot3...1jJSuj9IAg",
  #  "uuid": "5fd41241-26b2-470d-abd3-8dd10dada1be"
  # }
  # Error Responses
  # Status 422 (Unprocessable Entity) on validation error
  def start_registration(conn, params) do
    with {:ok, user} <- Accounts.register_user(params) do
      code = VerificationCode.next()
      conn
      |> request_email_verification(user, code)
      |> assign_verification_token(user, code)
      |> put_status(:created)
      |> render("registration.json", user: user)
    end
  end

  # GET /registrations/:uuid
  # Re-sends registration confirmation email, returns a new secret
  #
  # Success Response
  # 202 (Accepted)
  # {
  #  "email": "dave@brsg.io",
  #  "secret": "QTEyOEdDTQ.O5seRh15OJot3...1jJSuj9IAg",
  #  "uuid": "5fd41241-26b2-470d-abd3-8dd10dada1be"
  # }
  #
  # Error Responses
  # Status 400 (Bad Request) if email is already verified
  def continue_registration(conn, %{"uuid" => uuid}) do
    with user = Accounts.user_by_uuid(uuid) do
      case user.email_verified do
        true ->
          conn
          |> put_status(:bad_request)
          |> render("empty.json")
        false ->
          code = VerificationCode.next()
          conn
          |> request_email_verification(user, code)
          |> assign_verification_token(user, code)
          |> put_status(:accepted)
          |> render("registration.json", user: user)
      end
    end
  end

  # PATCH /registrations/:uuid
  #
  # Request
  # {"secret":"", "code":""}
  #
  # Success Response
  # 200 (OK)
  # Location /api/users/5fd41241-26b2-470d-abd3-8dd10dada1be
  # { ...user.json... }
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  def complete_registration(conn, %{"secret" => token, "uuid" => uuid, "code" => code}) do
    token_data = build_token_data(uuid,  code)
    with {:ok, :matched} <- Token.check_verification_token(token, token_data),
         user = Accounts.user_by_uuid(uuid)
    do
      updates = %{uuid: user.uuid, active: true, email_verified: true}
      with {:ok, %User{} = user} <- Accounts.update_user(user, updates) do
        conn
        |> Guardian.Plug.sign_in(user)
        |> Session.put_token_cookie()
        |> put_status(:ok)
        |> put_resp_header("Location", Routes.user_path(NabooWeb.Endpoint, :profile, user))
        |> put_view(NabooWeb.UserView)
        |> render("user.json", user: user)
      end
    end
  end

  # ############################################################
  # Utilities
  # ############################################################

  defp request_email_verification(conn, user, code) do
    Email.confirm_registration(conn, user, code)
    |> Mailer.deliver_later()
    conn
  end

  # store a token encoding the verification code in the user session
  defp assign_verification_token(conn, user, code) do
    token_data = build_token_data(user.uuid, Integer.to_string(code))
    token = Token.generate_verification_token(token_data)
    conn
    |> assign(:secret, token)
  end

  defp build_token_data(uuid, code) do
    uuid <> ":" <> code
  end

end

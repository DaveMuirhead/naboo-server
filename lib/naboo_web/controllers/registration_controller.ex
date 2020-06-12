defmodule NabooWeb.RegistrationController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias NabooWeb.Mailer
  alias NabooWeb.Token
  alias NabooWeb.Router.Helpers, as: Routes

  action_fallback NabooWeb.FallbackController

  # POST /registrations
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
  # Location /api/users/5fd41241-26b2-470d-abd3-8dd10dada1be
  # {
  #  "email": "dave@brsg.io",
  #  "secret": "QTEyOEdDTQ.O5seRh15OJot3...1jJSuj9IAg",
  #  "uuid": "5fd41241-26b2-470d-abd3-8dd10dada1be"
  # }
  # Error Responses
  # Status 422 (Unprocessable Entity) on validation error
  def start_registration(conn, params) do
    with {:ok, user} <- Accounts.register_user(params)
      do
      conn
      |> request_email_verification(user.uuid, user.email)
      |> assign(:user, user)
      |> put_status(:created)
      |> put_resp_header("Location", Routes.user_path(NabooWeb.Endpoint, :profile, user))
      |> render("registration.json")
    end
  end

  # PATCH /registrations/:uuid
  #
  # Request
  # {"secret":"", "code":""}
  #
  # Success Response
  # 200 (OK) with UserView user.json
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  def complete_registration(conn, params) do
    token = params["secret"]
    token_data = build_token_data(params["uuid"],  params["code"])
    with {:ok, :matched} <- Token.check_verification_token(token, token_data),
         user = Accounts.user_by_uuid(params["uuid"])
    do
      updates = %{uuid: user.uuid, active: true, email_verified: true}
      with {:ok, %User{} = user} <- Accounts.update_user(user, updates) do
        conn
        |> assign(:user, user)
        |> put_status(:ok)
        |> put_view(NabooWeb.UserView)
        |> render("user.json")
      end
    end
  end

  # ############################################################
  # Utilities
  # ############################################################

  defp request_email_verification(conn, user_uuid, new_email_address) do
    # generate verification code between 100000 and 999999 (ensure 6 chars)
    :random.seed(:erlang.now())
    code = :random.uniform(899999) + 100000

    # send verification code in email
    Mailer.deliver_email_verification_request(new_email_address, code)

    # store a token encoding the verification code in the user session
    token_data = build_token_data(user_uuid, Integer.to_string(code))
    token = Token.generate_verification_token(token_data)
    conn
    |> assign(:secret, token)
  end

  defp build_token_data(user_uuid, code) do
    user_uuid <> ":" <> code
  end

end

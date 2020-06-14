defmodule NabooWeb.PasswordController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias NabooWeb.Email
  alias NabooWeb.Mailer
  alias NabooWeb.Token
  alias NabooWeb.Router.Helpers, as: Routes

  action_fallback NabooWeb.FallbackController

  # POST /password-resets
  #
  # Request
  # {
  #	  "email": "",
  #   "reset_form_url": ""
  # }
  #
  # Success Response
  # Status 202 (Accepted)
  #
  # Error Responses
  # Status 422 (Unprocessable Entity) on validation error
  def start_password_reset(conn, %{"email" => email, "reset_form_url" => reset_form_url}) do
    token = Token.generate_verification_token(email)
    reset_link = reset_form_url <> "/" <> token
    Email.reset_password(conn, email, reset_link)
    |> Mailer.deliver_later()
    conn
      |> put_status(:accepted)
      |> render("accepted.json")
  end

  # PATCH /password-resets/:secret
  #
  # Request
  # {"password":""}
  #
  # Success Response
  # 200 (OK) with no content
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  def complete_password_reset(conn, %{"password" => password, "secret" => secret} = attrs) do
    with email <- Token.decrypt_token(secret),
         %User{uuid: uuid} = Accounts.user_by_email(email),
         {:ok, _user} <- Accounts.reset_password(%{"uuid" => uuid, "password" => password})
    do
      conn
        |> send_resp(200, "")
    end
  end

end

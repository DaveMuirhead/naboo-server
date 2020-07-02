defmodule NabooWeb.PasswordController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.User
  alias Naboo.Auth.Authenticator
  alias NabooWeb.Email
  alias NabooWeb.Mailer
  alias NabooWeb.Token
  alias NabooWeb.Router.Helpers, as: Routes

  action_fallback NabooWeb.FallbackController

  # POST /password-resets
  #
  # Request
  # { "email": "", "reset_form_url": "" }
  #
  # Success Response
  #  Status 202 (Accepted)
  #
  # Error Responses
  #  422 (Unprocessable Entity) on validation error
  def start_password_reset(conn, %{"email" => email, "reset_form_url" => reset_form_url}) do
    user = Accounts.user_by_email(email)
    if (user != nil and user.active) do
      token = Token.generate_verification_token(email)
      reset_link = reset_form_url <> "?token=" <> token
      Email.reset_password(conn, email, reset_link)
      |> Mailer.deliver_later()
    end
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
  #  200 (OK) with no content
  #
  # Error Responses
  #  401 (Unauthorized) if token is expired
  def complete_password_reset(conn, %{"password" => password, "secret" => secret} = attrs) do
    with email <- Token.decrypt_token(secret),
         %User{} = user = Accounts.user_by_email(email),
         {:ok, _user} <- Accounts.update_password(user, %{password: password})
    do
      conn
        |> send_resp(200, "")
    end
  end

  # PATCH /users/:uuid/password
  #
  # Request
  # {"old_password:"", "new_password":""}
  # Success Response
  # 200 (OK) with no content
  #
  # Error Responses
  #  401 (Unauthorized) if old_password does not match current_password
  #  422 (Unprocessable Entity) if any validation error occurs
  def change_password(conn, %{"old_password" => old_password, "new_password" => new_password} = attrs) do
    with user <- Guardian.Plug.current_resource(conn),
         {:ok, user} <- Authenticator.check_password(user, old_password),
         {:ok, user} <- Accounts.update_password(user, %{password: new_password})
    do
      conn
      |> send_resp(200, "")
    end
  end

end

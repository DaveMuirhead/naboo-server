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
  # { "email": "", "reset_form_url": "" }
  #
  # Success Response
  #  Status 202 (Accepted)
  #
  # Error Responses
  #  422 (Unprocessable Entity) on validation error
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
  #  200 (OK) with no content
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
         {:ok, user} <- Accounts.change_password(user, attrs)
    do
      conn
      |> send_resp(200, "")
    else
      {:error, :validation_failure, %{password: [:unuthenticated]}} ->
        conn
        |> send_resp(401, "")
      {:error, :validation_failure, errors} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(NabooWeb.ValidationView)
        |> render("error.json", errors: errors)
      _ ->
        conn
        |> send_resp(422, "")
    end
  end

end

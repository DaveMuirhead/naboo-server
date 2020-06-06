defmodule NabooWeb.AuthController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Authenticator
  alias Ueberauth.Auth
  alias Ueberauth.Strategy.Helpers

  plug Ueberauth

  action_fallback NabooWeb.FallbackController

  # we should never get here for a configured OAuth2 strategy
  def request(conn, %{"provider" => provider}) do
    IO.puts("AuthController.request called for provider '#{provider}'")
    render(conn, "error.json", status: :bad_request, message: "#{provider} is not configured in config/ueberauth.exs or else URI path doesn't match ueberauth configuration")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    with {:ok, user} <- find_or_create(auth, params) do
      conn = conn
        |> Guardian.Plug.sign_in(Naboo.Auth.Guardian, user)
      token = Guardian.Plug.current_token(conn)
      render(conn, "signed_in.json", user: user, token: token)
    end
  end

  defp find_or_create(%Auth{provider: :identity} = auth, %{"action" => "signup"} = params) do
    IO.puts("AuthController.find_or_create - identity signup")
    account_type = params["account_type"]
    email = params["email"]
    full_name = params["full_name"]
    password = params["password"]
    Accounts.register_user(params)
  end

  defp find_or_create(%Auth{provider: :identity} = auth, %{"action" => "login"} = params) do
    IO.puts("AuthController.find_or_create - identity login")
    email = params["email"]
    password = params["password"]
    case Accounts.user_by_email(email) do
      %User{} = user ->
        Authenticator.check_password(user, password)
      nil ->
        {:error, :unauthorized}
    end
  end

  defp find_or_create(%Auth{provider: :identity} = auth, %{"action" => _} = params) do
    IO.puts("AuthController.find_or_create - identity unknown action")
    {:error, :unprocessable_entity}
  end

  defp find_or_create(%Auth{provider: :auth0} = auth, _params) do
    IO.puts("AuthController.find_or_create for Auth0 called")
    IO.inspect(auth)
    {:error, "not yet implemented"}
#    uid = auth.uid
#    case Accounts.user_by_google_uid(uid) do
#      %User{} = user ->
#        {:ok, user}
#      nil ->
#        IO.puts("Accounts.user_by_google_uid ")
#        social_register(:google, auth)
#    end
  end

  defp find_or_create(%Auth{provider: other} = auth) do
    IO.puts("AuthController.find_or_create for #{other} called")
    {:error, "Ueberauth provider #{other} is not supported; see config/ueberauth.exs"}
  end

  defp social_register(:google, auth) do
    IO.puts("AuthController.social_register(:google, auth) called")
    IO.inspect(auth)
    attrs = %{
      "email" => auth.info.email,
      "first_name" => auth.info.given_name,
      "last_name" => auth.extra.user.family_name,
      "image_url" => auth.extra.user.picture,
      "google_uid" => auth.uid
    }
    IO.puts("social_register(:google,auth) called; attrs are")
    IO.inspect(attrs)
    {:error, "not yet implemented"}
  end

end

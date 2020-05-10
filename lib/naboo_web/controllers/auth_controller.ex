defmodule NabooWeb.AuthController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Authenticator
  alias Ueberauth.Auth
  alias Ueberauth.Strategy.Helpers

  plug Ueberauth

  action_fallback NabooWeb.FallbackController

  def request(conn, %{"provider" => "identity"}) do
    conn
    |> put_status(:method_not_allowed)
    |> render("error.json", status: :method_not_allowed, message: "identity provider does not support GET, use /api/sign_in instead")
    |> halt()
  end

  # we should never get here for a configured OAuth2 strategy
  def request(conn, %{"provider" => provider}) do
    IO.puts("AuthController.request called for provider '#{provider}'")
    render(conn, "error.json", status: :bad_request, message: "#{provider} is not a configured strategy in config/ueberauth.exs")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
#    IO.puts("AuthController.callback invoked with conn")
#    IO.inspect(conn)
    case find_or_create(auth) do
      {:ok, user} ->
        conn = conn
        |> Guardian.Plug.sign_in(Naboo.Auth.Guardian, user)
        token = Guardian.Plug.current_token(conn)
        render(conn, "signed_in.json", user: user, token: token)
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", status: :unauthorized, message: reason)
    end
  end

  defp find_or_create(%Auth{provider: :identity} = auth) do
    IO.puts("AuthController.find_or_create for :identity called")
    Authenticator.authenticate(auth.uid, auth.credentials.other.password)
  end

  defp find_or_create(%Auth{provider: :google} = auth) do
    IO.puts("AuthController.find_or_create for :google called")
    uid = auth.uid
    case Accounts.user_by_google_uid(uid) do
      %User{} = user ->
        {:ok, user}
      nil ->
        IO.puts("Accounts.user_by_google_uid ")
        social_register(:google, auth)
    end
  end

  defp find_or_create(%Auth{provider: other} = auth) do
    IO.puts("AuthController.find_or_create for #{other} called")
    {:error, "OAuth2 provider #{other} is not supported; see config/ueberauth.exs"}
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

defmodule NabooWeb.IdentityAuthController do
  use NabooWeb, :controller

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User
  alias Naboo.Auth.Authenticator
  alias Naboo.Auth.Guardian
  alias Ueberauth.Auth
  alias Ueberauth.Strategy.Helpers

  plug Ueberauth

  action_fallback NabooWeb.FallbackController

  # we should never get here for a configured OAuth2 strategy
  def request(conn, %{"provider" => provider}) do
    IO.puts("IdentityAuthController.request called for provider '#{provider}'")
    render(conn, "error.json", status: :bad_request, message: "#{provider} is not configured in config/ueberauth.exs or else URI path doesn't match ueberauth configuration")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"action" => "signup"} = params) do
    with {:ok, user} <- Accounts.register_user(params) do

      # Create refresh token
      new_conn = Guardian.Plug.sign_in(
        conn,                 #conn
        Naboo.Auth.Guardian,  #impl
        user,                 #resource
        %{                    #claims
          "name" => user.full_name,
          "nickname" => user.nickname,
          "picture" => user.image,
          "email" => user.email,
          "email_verified" => user.email_verified
        },
        []                    #opts
      )
      refresh_token = Guardian.Plug.current_token(new_conn)

      # Create access token
      {:ok, _old_stuff, {access_token, %{"exp" => access_token_exp} = _new_claims}} =
        Guardian.exchange(refresh_token, "refresh", "access")

      conn
      |> put_resp_header("authorization", "Bearer #{access_token}")
      |> put_resp_header("x-expires", "#{access_token_exp}")
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> put_view(NabooWeb.AuthView)
      |> render("account_created.json", user: user, token: token)
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"action" => "login"} = params) do
    email = params["email"]
    password = params["password"]
    with {:ok, user} <- Authenticator.authenticate(email, password) do
      conn = sign_in(conn, user)
      token = Guardian.Plug.current_token(conn)
      conn
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> put_view(NabooWeb.AuthView)
      |> render("signed_in.json", user: user, token: token)
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"action" => _} = params) do
    IO.puts("AuthController.find_or_create - identity unknown action")
    {:error, :unprocessable_entity}
  end

  defp sign_in(conn, user) do
    new_conn = Guardian.Plug.sign_in(
      conn,                 #conn
      Naboo.Auth.Guardian,  #impl
      user,                 #resource
      %{                    #claims
        "name" => user.full_name,
        "nickname" => user.nickname,
        "picture" => user.image,
        "email" => user.email,
        "email_verified" => user.email_verified
      },
      []                    #opts
    )
    refresh_token = Guardian.Plug.current_token(new_conn)
  end

  defp generate_refresh_token(conn, user) do
    Guardian.Plug.sign_in(
      conn,                  #conn
      Naboo.Auth.Guardian,   #impl
      user,                  #resource
      %{                    #claims
        "name" => user.full_name,
        "nickname" => user.nickname,
        "picture" => user.image,
        "email" => user.email,
        "email_verified" => user.email_verified
      },
      token_type: "refresh"  #opts
    )
  end

  defp generate_access_token(conn, refresh_token) do
    case Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, _old_stuff, {jwt, %{"exp" => exp} = _new_claims}} ->
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render(MyProjWeb.AuthenticationView, "refresh.json", %{jwt: jwt})

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> Error.render(:invalid_credentials)
    end
  end

end

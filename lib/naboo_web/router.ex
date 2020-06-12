defmodule NabooWeb.Router do
  use NabooWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :maybe_authenticated do
    plug :accepts, ["json"]
    plug Naboo.Auth.Pipeline
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", NabooWeb do
    pipe_through :maybe_authenticated

    # User exists query - 200 OK or 404 Not Found
    get    "/users/email/:email",    EmailController,     :exists

    # Starts registration flow - 201 Created
    post   "/registrations",         RegistrationController, :start_registration

    # Completes registration flow - 200 OK
    # Expects {"secret":"", "code":""}, verifies code, marks user as
    # active and email verified, responds with 200 OK and user plus access token
    patch  "/registrations/:uuid",   RegistrationController, :complete_registration

    # Sign in
    post   "/sessions",              SessionController,   :sign_in

    # Sign out
    delete "/sessions",              SessionController,   :sign_out

    # Starts password reset flow for possibly unauthenticated user
    # Expects {"email":""} body, delivers verification email and responds with 202 Accepted
    # post   "/password-resets",       PasswordController,  :start_password_reset

    # Completes password reset flow for possibly unauthenticated user
    # Expects {"token":"","new_password":""}, replaces password and responds with 204 No Content
    # put    "/password-resets/:uuid", PasswordController,  :complete_password_reset

  end

  scope "/api", NabooWeb do
    pipe_through [:maybe_authenticated, :authenticated]

    # Get profile of current user based on session state
    get "/users/current",             UserController,   :current

    # Get profile of specified user
    get "/users/:uuid",               UserController,   :profile

    # Update user
    patch  "/users/:uuid",            UserController,   :update

    # Change password of current (authenticated) user
    # Expects {"old_password:"", "new_password":""}, applies change and responds
    # with 204 No Content
    # put    "/users/:uuid/password",   PasswordController,  :change_password

    # Starts email verification flow
    # Expects {"new_email":""}, delivers verification email and responds with 202 Accepted
    # post   "/email-verifications",    EmailController, :start_email_verification

    # Completes email verification flow
    # Expects {"secret":"", "new_email":"", "code":""}, verifies code, marks email
    # as verified and responds with 204 No Content
    # put    "/email-verifications",    EmailController, :complete_email_verification

  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: NabooWeb.Telemetry
    end
  end
end

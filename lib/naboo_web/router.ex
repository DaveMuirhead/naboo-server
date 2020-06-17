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
    plug Naboo.Auth.VerifyActive
  end

  scope "/api", NabooWeb do
    pipe_through :maybe_authenticated

    # Check user existence
    get    "/users/email/:email",           EmailController,     :exists

    # Register a user
    get    "/registrations/:uuid",          RegistrationController, :continue_registration
    post   "/registrations",                RegistrationController, :start_registration
    patch  "/registrations/:uuid",          RegistrationController, :complete_registration

    # Sign in
    post   "/sessions",                     SessionController,   :sign_in

    # Sign out
    delete "/sessions",                     SessionController,   :sign_out

    # Reset password (multi-step process)
    post   "/password-resets",             PasswordController,  :start_password_reset
    patch  "/password-resets/:secret",     PasswordController,  :complete_password_reset

  end

  scope "/api", NabooWeb do
    pipe_through [:maybe_authenticated, :authenticated]

    # Retrieve profile of signed in user
    get    "/users/current",                UserController,   :current

    # Retrieve profile of specified user
    get    "/users/:uuid",                  UserController,   :profile

    # Update user
    patch  "/users/:uuid",                  UserController,   :update

    # Change password of specified user
    put    "/users/:uuid/password-changes", PasswordController,  :change_password

    # Change email (mult-step process)
    post   "/users/:uuid/email-changes",    EmailController, :start_email_change
    patch  "/users/:uuid/email-changes",    EmailController, :complete_email_change

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

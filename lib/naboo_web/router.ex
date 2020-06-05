defmodule NabooWeb.Router do
  use NabooWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :maybe_authenticated do
    plug :accepts, ["json"]
    plug NabooWeb.AuthPipeline
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/v1/auth", NabooWeb do
    pipe_through :maybe_authenticated

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :callback

    get "/user/email/:email", UserController, :validate_email_exists
  end

#  scope "/v1/api", NabooWeb do
#    pipe_through :maybe_authenticated
#
#    post "/register", RegistrationController, :register #this one stays
#    post "/sign_in", SessionController, :sign_in # this one goes away
#  end

  scope "/v1/api", NabooWeb do
    pipe_through [:maybe_authenticated, :authenticated]

    get "/users/:uuid", UserController, :show
    get "/users/current", UserController, :current
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

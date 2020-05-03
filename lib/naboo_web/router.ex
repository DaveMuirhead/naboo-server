defmodule NabooWeb.Router do
  use NabooWeb, :router

  pipeline :maybe_authenticated do
    plug :accepts, ["json"]
    plug NabooWeb.AuthPipeline
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", NabooWeb do
    pipe_through :maybe_authenticated

    post "/register", RegistrationController, :register
    post "/sign_in", SessionController, :sign_in

  end

  scope "/api", NabooWeb do
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

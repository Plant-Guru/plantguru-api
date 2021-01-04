defmodule PlantGuruWeb.Router do
  use PlantGuruWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlantGuruWeb.APIAuthPlug, otp_app: :plantguru
    plug PlantGuruWeb.Plug.RequestWith
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug PlantGuruWeb.Plug.CSRF
  end

  pipeline :dashboard do
    plug PlantGuruWeb.Plug.EnsureAJAX
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: PlantGuruWeb.APIAuthErrorHandler
  end

  scope "/api/v1", PlantGuruWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :csrf]

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
    resources "/confirm-email", ConfirmationController, only: [:show]
  end

  scope "/api/v1", PlantGuruWeb.API.V1, as: :api_v1 do
    pipe_through :api

    get "/csrf", TokenController, :get_csrf
  end

  scope "/api/v1", PlanGuruWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :csrf, :api_protected]

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
      live_dashboard "/dashboard", metrics: PlantGuruWeb.Telemetry
    end
  end
end

defmodule AppPrototype.Router do
  use AppPrototype.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/signups", AppPrototype do
    pipe_through [:browser, :browser_auth]

    post "/get_started", SignupController, :get_started
    get "/:email_id", SignupController, :new
    post "/", SignupController, :create
  end

  scope "/auth", AppPrototype do
    pipe_through [:browser, :browser_auth]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :identity_callback
    delete "/", AuthController, :delete
  end

  scope "/", AppPrototype do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    get "/dashboard", DashboardController, :index
  end
end

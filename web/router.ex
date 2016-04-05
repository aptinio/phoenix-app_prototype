defmodule AppPrototype.Router do
  use AppPrototype.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppPrototype do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    post "/get_started", SignupController, :get_started
    get "/sign_up/:email_id", SignupController, :new
    post "/signups", SignupController, :create
  end

  scope "/auth", AppPrototype do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :identity_callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppPrototype do
  #   pipe_through :api
  # end
end

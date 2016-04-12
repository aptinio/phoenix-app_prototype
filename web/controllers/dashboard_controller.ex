defmodule AppPrototype.DashboardController do
  use AppPrototype.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: AppPrototype.GuardianErrorHandler

  def index(conn, _params, user, _claims) do
    render conn, "index.html", user: user
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :request, "identity"))
  end
end

defmodule AppPrototype.GuardianErrorHandler do
  use AppPrototype.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :request, "identity"))
  end
end

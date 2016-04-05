defmodule AppPrototype.AuthController do
  use AppPrototype.Web, :controller
  plug Ueberauth

  def request(conn, _params) do
    conn
    |> render("request.html", callback_url: Ueberauth.Strategy.Helpers.callback_url(conn))
  end
end

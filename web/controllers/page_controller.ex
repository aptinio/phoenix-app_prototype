defmodule AppPrototype.PageController do
  use AppPrototype.Web, :controller
  alias AppPrototype.Email

  plug :put_layout, "page.html"

  def index(conn, _params) do
    changeset = Email.changeset(%Email{})
    render conn, "index.html", changeset: changeset
  end
end

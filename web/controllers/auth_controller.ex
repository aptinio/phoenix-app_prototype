defmodule AppPrototype.AuthController do
  use AppPrototype.Web, :controller
  alias AppPrototype.{Repo,Person}
  import Ecto.Query, only: [from: 2]
  plug Ueberauth
  plug :put_layout, "bare.html"

  def request(conn, _params) do
    conn
    |> render("request.html", callback_url: Ueberauth.Strategy.Helpers.callback_url(conn))
  end

  def identity_callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case person_from_identity_auth(auth) do
      {:ok, person} ->
        conn
        |> put_flash(:info, "Logged in as #{person.first_name}.")
        |> Guardian.Plug.sign_in(person)
        |> redirect(to: page_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> render("request.html", callback_url: Ueberauth.Strategy.Helpers.callback_url(conn))
    end
  end

  defp person_from_identity_auth(auth) do
    person = Repo.one from p in Person,
      join: e in assoc(p, :emails),
      where: e.address == ^auth.info.email,
      preload: [{:emails, e}, :access]

    password = auth.credentials.other.password

    if (person || Comeonin.Bcrypt.dummy_checkpw()) &&
        Comeonin.Bcrypt.checkpw(password, person.access.password_hash) do
      {:ok, person}
    else
      {:error, "Incorrect email or password."}
    end
  end
end

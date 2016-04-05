defmodule AppPrototype.SignupController do
  use AppPrototype.Web, :controller
  alias AppPrototype.{Org,Person,Email}

  def get_started(conn, %{"email" => email_params}) do
    changeset = Email.changeset(%Email{}, email_params)

    case Repo.insert(changeset) do
      {:ok, email} ->
        conn
        |> render("thanks.html", email_address: email.address)
      {:error, changeset} ->
        conn
        |> render(AppPrototype.PageView, :index, changeset: changeset)
    end
  end

  def new(conn, %{"email_id" => email_id}) do
    email = Repo.get(Email, email_id)

    changeset = Org.changeset(%Org{people: [%Person{}]})
    render(conn, "new.html", changeset: changeset, email: email)
  end

  def create(conn, %{"org" => org_params, "email" => email_params}) do
    email = Repo.get(Email, email_params["id"])
    changeset = Org.changeset(%Org{}, org_params)

    case Repo.insert(changeset) do
      {:ok, org} ->
        [person|_] = org.people

        email
        |> Ecto.Changeset.change(person_id: person.id, confirmed_at: Ecto.DateTime.utc)
        |> Repo.update!

        conn
        |> put_flash(:info, "Registration successfully completed.")
        |> redirect(to: auth_path(conn, :request, "identity"))

      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset, email: email)
    end
  end
end

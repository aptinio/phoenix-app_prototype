defmodule AppPrototype.SignupController do
  use AppPrototype.Web, :controller
  alias AppPrototype.{Email}

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
end

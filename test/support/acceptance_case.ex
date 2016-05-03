defmodule AppPrototype.AcceptanceCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import Ecto.Model
      import Ecto.Query, only: [from: 2, last: 2]
      import AppPrototype.Router.Helpers
      import AppPrototype.AcceptanceCase

      alias AppPrototype.Repo
      alias AppPrototype.AcceptanceCase.{GetStartedForm,SignupForm,LoginForm}

      @endpoint AppPrototype.Endpoint
    end
  end

  setup(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppPrototype.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AppPrototype.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(AppPrototype.Repo, self())
    Hound.start_session(metadata: metadata)

    :ok
  end

  defmodule GetStartedForm do
    def submit(email: email) do
      form = form()
      fill_field(email_input(form), email)
      submit_element(form)
    end

    defp email_input(form) do
      find_within_element(form, :id, "email_address")
    end

    def form do
      find_element(:css, "[method='post'][action='/signups/get_started']")
    end
  end

  defmodule SignupForm do
    def submit(first_name: first_name,
               last_name: last_name,
               org: org,
               password: password) do

      form = form()
      fill_field(first_name_input(form), first_name)
      fill_field(last_name_input(form), last_name)
      fill_field(org_input(form), org)
      fill_field(password_input(form), password)
      submit_element(form)
    end

    def first_name_input(form) do
      find_within_element(form, :id, "org_people_0_first_name")
    end

    def last_name_input(form) do
      find_within_element(form, :id, "org_people_0_last_name")
    end

    def org_input(form) do
      find_within_element(form, :id, "org_name")
    end

    def password_input(form) do
      find_within_element(form, :id, "org_people_0_access_password")
    end

    defp form do
      find_element(:css, "[method='post'][action='/signups']")
    end
  end

  defmodule LoginForm do
    def log_in(email: email, password: password) do
      form = form()
      fill_field(email_input(form), email)
      fill_field(password_input(form), password)
      submit_element(form)
    end

    def email_input(form) do
      find_within_element(form, :name, "email")
    end

    def password_input(form) do
      find_within_element(form, :name, "password")
    end

    defp form do
      find_element(:css, "[method='post'][action='/auth/identity/callback']")
    end
  end
end

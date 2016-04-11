defmodule AppPrototype.SignupAcceptanceTest do
  use AppPrototype.AcceptanceCase
  alias AppPrototype.{Email}

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

  def log_out do
    find_element(:css, "[value='Log out']")
    |> submit_element
  end

  def log_in_link_present? do
    element?(:link_text, "Log in")
  end

  def log_out_button_present? do
    element?(:css, "[value='Log out']")
  end

  test "sign up process" do
    navigate_to "/"

    assert log_in_link_present?
    refute log_out_button_present?

    GetStartedForm.submit(email: "")
    assert visible_page_text =~ "can't be blank"

    GetStartedForm.submit(email: "foo@bar.baz")
    assert visible_page_text =~ "Thanks"
    assert visible_page_text =~ "We sent you an email at foo@bar.baz"

    refute log_in_link_present?
    refute log_out_button_present?

    email = Email |> last(:inserted_at) |> Repo.one
    assert "foo@bar.baz" == email.address

    navigate_to "/"

    GetStartedForm.submit(email: "foo@bar.baz")
    assert visible_page_text =~ "has already been taken"

    navigate_to "/signups/wrong"
    assert visible_page_text =~ "Page not found"
    refute log_out_button_present?

    navigate_to "/signups/#{email.id}"

    refute log_in_link_present?
    refute log_out_button_present?

    SignupForm.submit(first_name: "",
                      last_name: "",
                      org: "",
                      password: "")
    assert visible_page_text =~ "Organization\ncan't be blank"
    assert visible_page_text =~ "First name\ncan't be blank"
    assert visible_page_text =~ "Password\ncan't be blank"

    SignupForm.submit(first_name: "Foo",
                      last_name: "Bar",
                      org: "Bar Corp.",
                      password: "foobarbaz")
    assert visible_page_text =~ "Registration successfully completed."

    refute log_in_link_present?
    refute log_out_button_present?

    LoginForm.log_in(email: "foo@bar.baz", password: "wrong")
    assert visible_page_text =~ "Incorrect email or password."

    refute log_in_link_present?
    refute log_out_button_present?

    navigate_to "/signups/#{email.id}"

    LoginForm.log_in(email: "wrong@bar.baz", password: "foobarbaz")
    assert visible_page_text =~ "Incorrect email or password."

    LoginForm.log_in(email: "foo@bar.baz", password: "foobarbaz")
    assert visible_page_text =~ "Logged in as Foo."

    assert visible_page_text =~ "Bar Corp."

    refute log_in_link_present?
    assert log_out_button_present?

    navigate_to "/dashboard"

    refute log_in_link_present?
    assert log_out_button_present?

    log_out

    assert log_in_link_present?
    refute log_out_button_present?

    navigate_to "/dashboard"

    refute log_in_link_present?
    refute log_out_button_present?

    assert visible_page_text =~ "Authentication required"
    LoginForm.log_in(email: "foo@bar.baz", password: "foobarbaz")
  end
end

defmodule AppPrototype.SignupAcceptanceTest do
  use AppPrototype.AcceptanceCase
  alias AppPrototype.{Email}

  def log_out do
    find_element(:link_text, "Log out")
    |> submit_element
  end

  def log_in_link_present? do
    element?(:link_text, "Log in")
  end

  def log_out_button_present? do
    element?(:link_text, "Log out")
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

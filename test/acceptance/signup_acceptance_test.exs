defmodule AppPrototype.SignupAcceptanceTest do
  use AppPrototype.AcceptanceCase

  defmodule GetStartedForm do
    def submit(email: email) do
      form = form()
      fill_field(email_input(form), email)
      submit_element(form)
    end

    defp email_input(form) do
      find_within_element(form, :id, "email_address")
    end

    defp form do
      find_element(:css, "[method='post'][action='/get_started']")
    end
  end

  test "sign up process" do
    navigate_to "/"

    GetStartedForm.submit(email: "")
    assert String.contains?(visible_page_text, "can't be blank")

    GetStartedForm.submit(email: "foo@bar.baz")
    assert String.contains?(visible_page_text, "Thanks")
    assert String.contains?(visible_page_text, "We sent you an email at foo@bar.baz")
  end
end

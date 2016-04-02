defmodule AppPrototype.EmailTest do
  use AppPrototype.ModelCase

  alias AppPrototype.Email

  @valid_email %Email{address: "foo@bar.baz"}

  test "errors on address" do
    Repo.insert(@valid_email)

    assert_errors_on(@valid_email, :address, %{
     "can't be blank" => [nil, "", " \n\t"],
     "has invalid format" => ["foo", "foo@bar", "@foo.", "foo.bar", "@foo.bar"],
     "has already been taken" => ["foo@bar.baz"]
    })
  end
end

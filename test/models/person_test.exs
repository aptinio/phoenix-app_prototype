defmodule AppPrototype.PersonTest do
  use AppPrototype.ModelCase

  alias AppPrototype.Person

  @valid_person %Person{first_name: "John", last_name: "Doe"}

  test "errors on name" do
    assert_errors_on(@valid_person, :first_name, %{
     "can't be blank" => [nil, "", " \n\t"]
    })
  end
end

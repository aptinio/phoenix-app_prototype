defmodule AppPrototype.AccessTest do
  use AppPrototype.ModelCase

  alias AppPrototype.Access

  @valid_access %Access{password: "foobarbaz"}

  test "errors on password" do
    assert_errors_on(@valid_access, :password, %{
     "can't be blank" => [nil, "", " \n\t"]
    })
  end
end

defmodule AppPrototype.OrgTest do
  use AppPrototype.ModelCase

  alias AppPrototype.Org

  @valid_org %Org{name: "Acme Corp."}

  test "errors on name" do
    assert_errors_on(@valid_org, :name, %{
     "can't be blank" => [nil, "", " \n\t"]
    })
  end
end

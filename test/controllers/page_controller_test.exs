defmodule AppPrototype.PageControllerTest do
  use AppPrototype.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to AppPrototype!"
  end
end

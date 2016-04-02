defmodule AppPrototype.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias AppPrototype.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import AppPrototype.ModelCase
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppPrototype.Repo)
  end

  @doc """
  Helper for returning list of errors in model when passed certain data.

  ## Examples

  Given a User model that lists `:name` as a required field and validates
  `:password` to be safe, it would return:

      iex> errors_on(%User{}, %{password: "password"})
      [password: "is unsafe", name: "is blank"]

  You could then write your assertion like:

      assert {:password, "is unsafe"} in errors_on(%User{}, %{password: "password"})

  You can also create the changeset manually and retrieve the errors
  field directly:

      iex> changeset = User.changeset(%User{}, password: "password")
      iex> {:password, "is unsafe"} in changeset.errors
      true
  """
  def errors_on(model, data) do
    model.__struct__.changeset(model, data).errors
  end

  def assert_errors_on(model, field, error_values) do
    Enum.each(error_values, fn({error, values}) ->
      Enum.each(values, fn(value) ->
        {:error, changeset} =
          model
          |> model.__struct__.changeset(%{field => value})
          |> AppPrototype.Repo.insert
        message = "Expected error \"#{field} #{error}\" when it is #{inspect value}"
        assert {field, error} in changeset.errors, message
      end)
    end)
  end
end

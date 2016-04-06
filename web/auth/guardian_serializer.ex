defmodule AppPrototype.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias AppPrototype.{Repo,Person}

  def for_token(person = %Person{}), do: { :ok, "Person:#{person.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("Person:" <> id), do: { :ok, Repo.get(Person, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end

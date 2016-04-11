defmodule AppPrototype.GuardianSerializer do
  @behaviour Guardian.Serializer

  require Ecto.Query

  alias AppPrototype.{Repo,Person}

  def for_token(person = %Person{}), do: { :ok, "Person:#{person.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("Person:" <> id) do
    person = Repo.one Ecto.Query.from p in Person,
      where: p.id == ^id,
      preload: [:org]

    {:ok, person}
  end

  def from_token(_), do: { :error, "Unknown resource type" }
end

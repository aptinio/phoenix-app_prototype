defmodule AppPrototype.Org do
  use AppPrototype.Web, :model

  schema "orgs" do
    field :name, :string
    has_many :people, AppPrototype.Person

    timestamps
  end

  @allowed_fields ~w(name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> cast_assoc(:people)
    |> validate_required(:name)
  end
end

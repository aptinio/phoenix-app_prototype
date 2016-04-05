defmodule AppPrototype.Person do
  use AppPrototype.Web, :model

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    belongs_to :org, AppPrototype.Org
    has_many :emails, AppPrototype.Email
    has_one :access, AppPrototype.Access

    timestamps
  end

  @allowed_fields ~w(first_name last_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> cast_assoc(:access)
    |> validate_required(:first_name)
  end
end

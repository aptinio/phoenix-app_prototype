defmodule AppPrototype.Email do
  use AppPrototype.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "emails" do
    field :address, :string
    field :is_primary, :boolean, default: false
    field :confirmed_at, Ecto.DateTime
    belongs_to :person, AppPrototype.Person

    timestamps
  end

  @allowed_fields ~w(address is_primary confirmed_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:address)
    |> validate_format(:address, ~r/\A\s*\z|^[A-Z0-9][A-Z0-9._%+-]{0,63}@(?:(?=[A-Z0-9-]{1,63}\.)[A-Z0-9]+(?:-[A-Z0-9]+)*\.){1,8}[A-Z]{2,63}$/i)
    |> unique_constraint(:address)
  end
end

defmodule AppPrototype.Access do
  use AppPrototype.Web, :model

  schema "access" do
    field :password_hash, :string
    belongs_to :person, AppPrototype.Person

    timestamps

    field :password, :string, virtual: true
  end

  @allowed_fields ~w(password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:password)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end
end

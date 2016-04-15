defmodule AppPrototype.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :org_id, references(:orgs, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:people, [:org_id])
  end
end

defmodule AppPrototype.Repo.Migrations.CreateAccess do
  use Ecto.Migration

  def change do
    create table(:access) do
      add :password_hash, :string, null: false
      add :person_id, references(:people, on_delete: :delete_all), null: false

      timestamps
    end

    create unique_index(:access, [:person_id])
  end
end

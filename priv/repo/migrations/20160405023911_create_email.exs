defmodule AppPrototype.Repo.Migrations.CreateEmail do
  use Ecto.Migration

  def change do
    create table(:emails, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :address, :string, null: false
      add :is_primary, :boolean, default: false, null: false
      add :confirmed_at, :datetime
      add :person_id, references(:people, on_delete: :delete_all)

      timestamps
    end

    create index(:emails, [:person_id])
    create unique_index(:emails, [:address])
    create unique_index(:emails, [:person_id], where: :is_primary, name: :primary_emails_person_id_index)
  end
end

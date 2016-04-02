defmodule AppPrototype.Repo.Migrations.CreateEmail do
  use Ecto.Migration

  def change do
    create table(:emails, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :address, :string, null: false
      add :is_primary, :boolean, default: false, null: false
      add :confirmed_at, :datetime

      timestamps
    end

    create unique_index(:emails, [:address])
  end
end

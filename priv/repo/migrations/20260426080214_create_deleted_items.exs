defmodule Kestrel.Repo.Migrations.CreateDeletedItems do
  use Ecto.Migration

  def change do
    create table(:deleted_items) do
      add :deleted_by, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :table_name, :string, null: false
      add :record_id, :binary_id, null: false
      add :data, :jsonb, null: false
      add :purge_after, :utc_datetime, null: false
      add :inserted_at, :utc_datetime, null: false
    end

    create index(:deleted_items, [:deleted_by])
  end
end

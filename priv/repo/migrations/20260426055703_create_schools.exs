defmodule Kestrel.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :start_date, :date
      add :end_date, :date
      add :notes, :string, size: 255

      timestamps()
    end

    create index(:schools, [:user_id])
  end
end

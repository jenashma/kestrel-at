defmodule Kestrel.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      add :assignment_id,
          references(
            :assignments,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      add :name, :string, null: false
      add :due_at, :utc_datetime, null: false
      add :completed_at, :utc_datetime
      add :order, :integer, null: false

      timestamps()
    end

    create index(:steps, [:user_id])
    create index(:steps, [:assignment_id])
  end
end

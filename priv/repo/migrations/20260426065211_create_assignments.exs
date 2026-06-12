defmodule Kestrel.Repo.Migrations.CreateAssignments do
  use Ecto.Migration

  def change do
    create table(:assignments) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :school_id, references(:schools, type: :binary_id, on_delete: :restrict), null: false
      add :term_id, references(:terms, type: :binary_id, on_delete: :restrict), null: false
      add :course_id, references(:courses, type: :binary_id, on_delete: :restrict), null: false
      add :status_id, references(:statuses, type: :binary_id, on_delete: :restrict), null: false
      add :type_id, references(:types, type: :binary_id, on_delete: :restrict), null: false
      add :name, :string, null: false
      add :topic, :string
      add :is_prioritized, :boolean, default: false, null: false
      add :priority, :float
      add :group, :integer
      add :due_date, :utc_datetime, null: false
      add :unlock_date, :utc_datetime, null: false
      add :submission_method, :string
      add :notes, :string, size: 255

      timestamps()
    end

    create index(:assignments, [:user_id])
    create index(:assignments, [:school_id])
    create index(:assignments, [:term_id])
    create index(:assignments, [:course_id])
    create index(:assignments, [:status_id])
    create index(:assignments, [:type_id])
    create index(:assignments, [:user_id, :status_id, :due_date, :unlock_date])
  end
end

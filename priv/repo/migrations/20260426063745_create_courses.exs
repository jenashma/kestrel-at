defmodule Kestrel.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string
      add :code, :string, null: false
      add :credit_hours, :integer
      add :color, :string
      add :notes, :string, size: 255

      timestamps()
    end

    create index(:courses, [:user_id])
  end
end

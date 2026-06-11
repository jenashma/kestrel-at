defmodule Kestrel.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      add :assignment_id,
          references(
            :assignments,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      add :display_text, :string, null: false
      add :uri, :string, null: false

      timestamps()
    end

    create index(:links, [:user_id])
    create index(:links, [:assignment_id])
  end
end

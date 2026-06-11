defmodule Kestrel.Repo.Migrations.CreateErrorLogs do
  use Ecto.Migration

  def change do
    create table(:error_logs) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nilify_all)
      add :error_type, :string, null: false
      add :message, :text, null: false
      add :stack_trace, :text
      add :inserted_at, :utc_datetime, null: false
    end
  end
end

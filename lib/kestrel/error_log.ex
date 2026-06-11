defmodule Kestrel.ErrorLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "error_logs" do
    field :error_type, :string
    field :message, :string
    field :stack_trace, :string
    field :inserted_at, :utc_datetime

    belongs_to :user, Kestrel.Accounts.User
  end

  def changeset(error_log, attrs) do
    error_log
    |> cast(attrs, [:error_type, :message, :stack_trace, :inserted_at, :user_id])
    |> validate_required([:error_type, :message, :inserted_at])
  end
end

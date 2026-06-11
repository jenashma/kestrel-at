defmodule Kestrel.Assignments.Step do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "steps" do
    field :name, :string
    field :due_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :order, :integer

    belongs_to :user, Kestrel.Accounts.User
    belongs_to :assignment, Kestrel.Assignments.Assignment

    timestamps()
  end

  def changeset(step, attrs) do
    step
    |> cast(attrs, [:name, :due_at, :completed_at, :order, :user_id, :assignment_id])
    |> validate_required([:name, :due_at, :order, :user_id, :assignment_id])
  end
end

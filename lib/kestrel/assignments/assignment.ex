defmodule Kestrel.Assignments.Assignment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "assignments" do
    field :name, :string
    field :topic, :string
    field :is_prioritized, :boolean
    field :priority, :float
    field :group, :integer
    field :due_date, :utc_datetime
    field :unlock_date, :utc_datetime
    field :submission_method, :string
    field :notes, :string

    belongs_to :user, Kestrel.Accounts.User
    belongs_to :school, Kestrel.Assignments.School
    belongs_to :term, Kestrel.Assignments.Term
    belongs_to :course, Kestrel.Assignments.Course
    belongs_to :type, Kestrel.Assignments.Type
    belongs_to :status, Kestrel.Assignments.Status

    timestamps()
  end

  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [
      :name,
      :topic,
      :is_prioritized,
      :priority,
      :group,
      :due_date,
      :unlock_date,
      :submission_method,
      :notes,
      :user_id,
      :school_id,
      :term_id,
      :course_id,
      :type_id,
      :status_id
    ])
    |> validate_required([
      :name,
      :is_prioritized,
      :due_date,
      :unlock_date,
      :user_id,
      :school_id,
      :term_id,
      :course_id,
      :type_id,
      :status_id
    ])
  end
end

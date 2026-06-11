defmodule Kestrel.Assignments.Course do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "courses" do
    field :name, :string
    field :code, :string
    field :credit_hours, :integer
    field :color, :string
    field :notes, :string

    belongs_to :user, Kestrel.Accounts.User

    timestamps()
  end

  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :code, :credit_hours, :color, :notes, :user_id])
    |> validate_required([:code, :user_id])
  end
end

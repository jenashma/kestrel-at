defmodule Kestrel.Assignments.School do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "schools" do
    field :name, :string
    field :start_date, :date
    field :end_date, :date
    field :notes, :string

    belongs_to :user, Kestrel.Accounts.User

    timestamps()
  end

  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :start_date, :end_date, :notes, :user_id])
    |> validate_required([:name, :user_id])
  end
end

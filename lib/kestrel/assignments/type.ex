defmodule Kestrel.Assignments.Type do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "types" do
    field :name, :string

    belongs_to :user, Kestrel.Accounts.User

    timestamps()
  end

  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end

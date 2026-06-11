defmodule Kestrel.Assignments.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "links" do
    field :display_text, :string
    field :uri, :string

    belongs_to :user, Kestrel.Accounts.User
    belongs_to :assignment, Kestrel.Assignments.Assignment

    timestamps()
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:display_text, :uri, :user_id, :assignment_id])
    |> validate_required([:display_text, :uri, :user_id, :assignment_id])
  end
end

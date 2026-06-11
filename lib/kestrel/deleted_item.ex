defmodule Kestrel.DeletedItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "deleted_items" do
    field :table_name, :string
    field :record_id, :binary_id
    field :data, :map
    field :purge_after, :utc_datetime
    field :inserted_at, :utc_datetime

    belongs_to :deleter, Kestrel.Accounts.User, foreign_key: :deleted_by
  end

  def changeset(deleted_item, attrs) do
    deleted_item
    |> cast(attrs, [:table_name, :record_id, :data, :purge_after, :inserted_at, :deleted_by])
    |> validate_required([
      :table_name,
      :record_id,
      :data,
      :purge_after,
      :inserted_at,
      :deleted_by
    ])
  end
end

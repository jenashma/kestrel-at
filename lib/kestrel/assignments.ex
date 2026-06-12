defmodule Kestrel.Assignments do
  @moduledoc """
  Context module for managing assignments and related data.
  """

  import Ecto.Query
  alias Kestrel.Repo
  alias Kestrel.Assignments.Assignment
  alias Kestrel.Assignments.Course
  alias Kestrel.Assignments.Status
  alias Kestrel.Assignments.Step
  alias Kestrel.Assignments.Type

  @doc """
  Returns all non-archived assignments for a given user. Assignments are ordered by priority, then due date, then name. Returns an empty list if the user has no non-archived assignments.

  ## Parameters

  - `user` - A `%Kestrel.Accounts.User{}` struct representing the
    authenticated user whose assignments to fetch.

  ## Returns

  A list of maps, each containing:
  - `:id` - UUID
  - `:name` - string
  - `:priority` - float
  - `:due_date` - UTC datetime
  - `:unlock_date` - UTC datetime
  - `:notes` - string or nil
  - `:course_code` - string
  - `:type_name` - string
  - `:status_name` - string
  - `:step_count` - integer
  - `:completed_step_count` - integer

  ## Examples

      iex> list_assignments(user)
      [%{name: "Assignment 1", ...}, ...]
  """
  @spec list_assignments(Kestrel.Accounts.User.t()) :: map()
  def list_assignments(user) do
    archived_status = Repo.get_by(Status, name: "Archived")

    Assignment
    |> join(:inner, [a], c in Course, on: a.course_id == c.id)
    |> join(:inner, [a, c], t in Type, on: a.type_id == t.id)
    |> join(:inner, [a, c, t], st in Status, on: a.status_id == st.id)
    |> join(:left, [a, c, t, st], s in Step, on: s.assignment_id == a.id)
    |> where([a], a.user_id == ^user.id)
    |> where([a], a.status_id != ^archived_status.id)
    |> group_by([a, c, t, st], [a.id, c.code, t.name, st.name])
    |> order_by([a], asc: a.priority, asc: a.due_date, asc: a.name)
    |> select([a, c, t, st, s], %{
      id: a.id,
      name: a.name,
      priority: a.priority,
      due_date: a.due_date,
      unlock_date: a.unlock_date,
      notes: a.notes,
      course_code: c.code,
      type_name: t.name,
      status_name: st.name,
      step_count: count(s.id),
      completed_step_count: count(s.completed_at)
    })
    |> Repo.all()
  end

  def filter_assignments(:upcoming, assignments, now) do
    # upcoming =
    Enum.filter(assignments, fn a ->
      DateTime.compare(a.unlock_date, now) == :gt and a.status_name != "Complete"
    end)

    # group_by_priority(upcoming, now)
  end

  def filter_assignments(:available, assignments, now) do
    # available =
    Enum.filter(assignments, fn a ->
      DateTime.compare(a.unlock_date, now) != :gt and a.status_name != "Complete"
    end)

    # available_by_priority =
    #   Enum.filter(available, fn a ->
    #     a.is_priority == true
    #   end)

    # available_by_date =
    #   Enum.filter(available, fn a ->
    #     a.is_priority != true
    #   end)

    # {group_by_priority(available_by_priority, now), group_by_priority(available_by_date, now)}
  end

  def filter_assignments(:completed, assignments, _now) do
    # completed =
    Enum.filter(assignments, fn a ->
      a.status_name == "Complete"
    end)

    # group_by_priority(completed, now)
  end

  # defp group_by_priority([%Assignment{}], now) do
  # end
end

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
    |> select([a, c, t, st, s], %{
      id: a.id,
      name: a.name,
      is_prioritized: a.is_prioritized,
      priority: a.priority,
      group: a.group,
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

  def filter_assignments(:available, assignments, now) do
    {priority_raw, date_raw} =
      assignments
      |> Enum.filter(fn a ->
        DateTime.compare(a.unlock_date, now) != :gt and a.status_name != "Complete"
      end)
      |> Enum.split_with(fn a -> a.is_prioritized == true end)

    priority_list =
      priority_raw
      |> Enum.group_by(fn a -> "available-by-priority-#{trunc(a.priority)}" end)
      |> Enum.map(fn {priority, list} -> {priority, Enum.sort_by(list, & &1.priority)} end)

    date_list =
      date_raw
      |> Enum.group_by(fn a -> "available-by-due-date-#{DateTime.to_date(a.due_date)}" end)
      |> Enum.map(fn {priority, list} ->
        {priority, Enum.sort_by(list, &{&1.course_code, &1.name})}
      end)

    {priority_list, date_list}
  end

  def filter_assignments(:upcoming, assignments, now) do
    assignments
    |> Enum.filter(fn a ->
      DateTime.compare(a.unlock_date, now) == :gt and a.status_name != "Complete"
    end)
    |> Enum.group_by(fn a -> "upcoming-#{DateTime.to_date(a.unlock_date)}" end)
    |> Enum.map(fn {priority, list} ->
      {priority,
       Enum.sort_by(
         Enum.sort_by(list, &{&1.course_code, &1.name}),
         & &1.due_date,
         DateTime
       )}
    end)
  end

  def filter_assignments(:completed, assignments, _now) do
    assignments
    |> Enum.filter(fn a -> a.status_name == "Complete" end)
    |> Enum.group_by(fn a -> "complete-#{DateTime.to_date(a.due_date)}" end)
    |> Enum.map(fn {priority, list} ->
      {priority, Enum.sort_by(list, &{&1.course_code, &1.name})}
    end)
  end
end

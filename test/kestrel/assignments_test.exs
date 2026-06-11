defmodule Kestrel.AssignmentsTest do
  use Kestrel.DataCase
  import Kestrel.Accounts

  alias Kestrel.Repo
  alias Kestrel.Accounts
  alias Kestrel.Accounts.User
  alias Kestrel.Assignments
  alias Kestrel.Assignments.Assignment
  alias Kestrel.Assignments.Course
  alias Kestrel.Assignments.Link
  alias Kestrel.Assignments.School
  alias Kestrel.Assignments.Status
  alias Kestrel.Assignments.Step
  alias Kestrel.Assignments.Term
  alias Kestrel.Assignments.Type

  setup do
    # The system user owns global data.
    system_user =
      Repo.insert!(
        %User{
          id: "00000000-0000-0000-0000-000000000000",
          email: "system@kestrel.internal",
          hashed_password: "definitely-a-real-hash"
        },
        on_conflict: :nothing
      )

    # Globals - required for all tests.
    not_started = Repo.insert!(%Status{user_id: system_user.id, name: "Not Started"})
    in_progress = Repo.insert!(%Status{user_id: system_user.id, name: "In Progress"})
    complete = Repo.insert!(%Status{user_id: system_user.id, name: "Complete"})
    archived = Repo.insert!(%Status{user_id: system_user.id, name: "Archived"})
    homework = Repo.insert!(%Type{user_id: system_user.id, name: "Homework"})
    discussion = Repo.insert!(%Type{user_id: system_user.id, name: "Discussion"})
    lab = Repo.insert!(%Type{user_id: system_user.id, name: "Lab"})
    quiz = Repo.insert!(%Type{user_id: system_user.id, name: "Quiz"})
    exam = Repo.insert!(%Type{user_id: system_user.id, name: "Exam"})

    # Return globally-scoped setup values.
    %{
      system_user: system_user,
      not_started: not_started,
      in_progress: in_progress,
      complete: complete,
      archived: archived,
      homework: homework,
      discussion: discussion,
      lab: lab,
      quiz: quiz,
      exam: exam
    }
  end

  describe "list_assignments/1" do
    setup %{
      system_user: system_user,
      not_started: not_started,
      in_progress: in_progress,
      complete: complete,
      archived: archived,
      homework: homework,
      discussion: discussion,
      lab: lab,
      quiz: quiz,
      exam: exam
    } do
      {:ok, data_user} =
        Accounts.register_user(%{
          email: "data_user@gmail.com",
          password: "thisuserhasdata"
        })

      {:ok, no_data_user} =
        Accounts.register_user(%{
          email: "no_data_user@gmail.com",
          password: "thisuserdoesnothavedata"
        })

      school =
        Repo.insert!(%School{
          user_id: data_user.id,
          name: "Oregon State",
          start_date: ~D[2025-03-30]
        })

      term =
        Repo.insert!(%Term{
          user_id: data_user.id,
          name: "Spring 2026",
          start_date: ~D[2026-03-30],
          end_date: ~D[2026-06-12]
        })

      course =
        Repo.insert!(%Course{
          user_id: data_user.id,
          name: "Intro to Databases",
          code: "CS 340"
        })

      base_case =
        Repo.insert!(%Assignment{
          user_id: data_user.id,
          school_id: school.id,
          term_id: term.id,
          course_id: course.id,
          type_id: homework.id,
          status_id: not_started.id,
          name: "Homework 1",
          due_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 5, :day),
          unlock_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), -10, :day),
          notes:
            "This assignment is the base case that the other assignments are compared to and should appear 2nd in the list."
        })

      diff_priority =
        Repo.insert!(%Assignment{
          user_id: data_user.id,
          school_id: school.id,
          term_id: term.id,
          course_id: course.id,
          type_id: homework.id,
          status_id: not_started.id,
          name: "Homework 1",
          due_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 5, :day),
          unlock_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), -10, :day),
          priority: 3.0,
          notes:
            "This assignment has a different priority than the base case and should appear 1st in the list."
        })

      diff_date =
        Repo.insert!(%Assignment{
          user_id: data_user.id,
          school_id: school.id,
          term_id: term.id,
          course_id: course.id,
          type_id: homework.id,
          status_id: not_started.id,
          name: "Homework 1",
          due_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 10, :day),
          unlock_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), -5, :day),
          notes:
            "This assignment has a different due date than the base case and should appear 4th in the list. It also has steps attached to it."
        })

      diff_name =
        Repo.insert!(%Assignment{
          user_id: data_user.id,
          school_id: school.id,
          term_id: term.id,
          course_id: course.id,
          type_id: homework.id,
          status_id: not_started.id,
          name: "Homework 2",
          due_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 5, :day),
          unlock_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), -10, :day),
          notes: "This assignment has a different name and should appear 3rd in the list."
        })

      diff_status =
        Repo.insert!(%Assignment{
          user_id: data_user.id,
          school_id: school.id,
          term_id: term.id,
          course_id: course.id,
          type_id: homework.id,
          status_id: archived.id,
          name: "Homework 1",
          due_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 5, :day),
          unlock_date: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), -10, :day),
          notes: "This assignment has been archived and should not appear in the list."
        })

      diff_step_1 =
        Repo.insert!(%Step{
          user_id: data_user.id,
          assignment_id: diff_date.id,
          name: "Initial Post",
          due_at: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 2, :day),
          order: 1
        })

      diff_step_2 =
        Repo.insert!(%Step{
          user_id: data_user.id,
          assignment_id: diff_date.id,
          name: "Peer Responses",
          due_at: DateTime.add(DateTime.truncate(DateTime.utc_now(), :second), 5, :day),
          order: 2
        })

      %{
        data_user: data_user,
        no_data_user: no_data_user,
        school: school,
        term: term,
        course: course,
        base_case: base_case,
        diff_priority: diff_priority,
        diff_date: diff_date,
        diff_name: diff_name,
        diff_status: diff_status,
        diff_step_1: diff_step_1,
        diff_step_2: diff_step_2
      }
    end

    test "checks that correct data is present", %{data_user: data_user} do
      result = Assignments.list_assignments(data_user)

      expected_keys = [
        :id,
        :name,
        :priority,
        :due_date,
        :unlock_date,
        :notes,
        :course_code,
        :type_name,
        :status_name,
        :step_count,
        :completed_step_count
      ]

      assert Enum.all?(result, fn assignment ->
               Enum.all?(expected_keys, &Map.has_key?(assignment, &1))
             end)
    end

    test "checks for proper sort order", %{
      data_user: data_user
    } do
      result = Assignments.list_assignments(data_user)

      # Unpacking the list of assignments.
      [first, second, third, fourth] = result

      # Check known values.
      assert first.priority == 3.0
      assert third.name == "Homework 2"
      assert fourth.step_count == 2

      # Check for expected differentiations.
      assert second.priority != first.priority
      assert second.name != third.name
      assert DateTime.compare(second.unlock_date, fourth.unlock_date) == :lt

      # Ensures the Archived assignment isn't present.
      assert Enum.all?(result, fn a -> a.status_name != "Archived" end)
    end

    test "user without data returns nothing", %{no_data_user: no_data_user} do
      result = Assignments.list_assignments(no_data_user)

      assert result == []
    end
  end
end

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kestrel.Repo.insert!(%Kestrel.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import DateShift

alias Kestrel.Repo
alias Kestrel.Accounts
alias Kestrel.Accounts.User
alias Kestrel.Assignments.Term
alias Kestrel.Assignments.Type
alias Kestrel.Assignments.Step
alias Kestrel.Assignments.School
alias Kestrel.Assignments.Course
alias Kestrel.Assignments.Status
alias Kestrel.Assignments.Assignment

# =============================================================================
# SYSTEM USER
# =============================================================================

system_user =
  Repo.insert!(%User{
    id: "00000000-0000-0000-0000-000000000000",
    email: "system@kestrel.internal",
    hashed_password: "fakehashrealwords",
    name: "System"
  })

# =============================================================================
# GLOBAL TYPES
# =============================================================================

homework = Repo.insert!(%Type{user_id: system_user.id, name: "Homework"})
_lab = Repo.insert!(%Type{user_id: system_user.id, name: "Lab"})
quiz = Repo.insert!(%Type{user_id: system_user.id, name: "Quiz"})
exam = Repo.insert!(%Type{user_id: system_user.id, name: "Exam"})
discussion = Repo.insert!(%Type{user_id: system_user.id, name: "Discussion"})
_reading = Repo.insert!(%Type{user_id: system_user.id, name: "Reading"})
_project = Repo.insert!(%Type{user_id: system_user.id, name: "Project"})

# =============================================================================
# GLOBAL STATUSES
# =============================================================================

not_started = Repo.insert!(%Status{user_id: system_user.id, name: "Not Started"})
in_progress = Repo.insert!(%Status{user_id: system_user.id, name: "In Progress"})
complete = Repo.insert!(%Status{user_id: system_user.id, name: "Complete"})
archived = Repo.insert!(%Status{user_id: system_user.id, name: "Archived"})

# =============================================================================
# Demo User
# =============================================================================

{:ok, user} =
  Accounts.register_user(%{
    email: "user@email.com",
    password: "demopassword",
    name: "User Name"
  })

user =
  Repo.update!(
    Ecto.Changeset.change(
      user,
      confirmed_at: DateTime.utc_now(:second)
    )
  )

# =============================================================================
# SCHOOL + TERM
# =============================================================================

osu =
  Repo.insert!(%School{
    user_id: user.id,
    name: "Oregon State University",
    start_date: Date.add(Date.utc_today(), -24),
    end_date: Date.add(Date.utc_today(), 52)
  })

winter_26 =
  Repo.insert!(%Term{
    user_id: user.id,
    name: "Winter 2026",
    start_date: Date.add(Date.utc_today(), -52),
    end_date: Date.add(Date.utc_today(), -25)
  })

spring_26 =
  Repo.insert!(%Term{
    user_id: user.id,
    name: "Spring 2026",
    start_date: Date.add(Date.utc_today(), -24),
    end_date: Date.add(Date.utc_today(), 52)
  })

# =============================================================================
# COURSES
# =============================================================================

cs261 =
  Repo.insert!(%Course{
    user_id: user.id,
    name: "Data Structures",
    code: "CS 261",
    credit_hours: 4
  })

cs290 =
  Repo.insert!(%Course{
    user_id: user.id,
    name: "Web Development",
    code: "CS 290",
    credit_hours: 4
  })

cs325 =
  Repo.insert!(%Course{
    user_id: user.id,
    name: "Analysis of Algorithms",
    code: "CS 325",
    credit_hours: 4
  })

econ =
  Repo.insert!(%Course{
    user_id: user.id,
    name: "Microeconomics",
    code: "ECON 201Z",
    credit_hours: 4
  })

ba260 =
  Repo.insert!(%Course{
    user_id: user.id,
    name: "Entrepreneurial Mindset",
    code: "BA 260",
    credit_hours: 3
  })

# =============================================================================
# ARCHIVED ASSIGNMENTS
# =============================================================================

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: winter_26.id,
  course_id: cs261.id,
  type_id: homework.id,
  status_id: archived.id,
  name: "Assignment 1",
  topic: "Static and Dynamic Arrays",
  unlock_date: shift_date(-5, :unlock),
  due_date: shift_date(5, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: winter_26.id,
  course_id: cs290.id,
  type_id: homework.id,
  status_id: archived.id,
  name: "Assignment 1",
  topic: "HTML and CSS",
  unlock_date: shift_date(5, :unlock),
  due_date: shift_date(10, :due),
  submission_method: "Canvas"
})

# =============================================================================
# CS 325 ASSIGNMENTS
# =============================================================================

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Assignment 1",
  topic: "Asymptotic Notations and Running Time",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: complete.id,
  name: "Module 1 Quiz",
  topic: "Asymptotic Notations and Running Time",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Assignment 2",
  topic: "Recursion and Recurrence Relations",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-4, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: complete.id,
  name: "Module 2 Quiz",
  topic: "Recursion and Recurrence Relations",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-4, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Assignment 3",
  topic: "Correctness of Algorithms and Divide & Conquer Technique",
  unlock_date: shift_date(-17, :unlock),
  due_date: shift_date(3, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: complete.id,
  name: "Module 3 Quiz",
  topic: "Correctness of Algorithms and Divide & Conquer Technique",
  unlock_date: shift_date(-17, :unlock),
  due_date: shift_date(3, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Assignment 4",
  topic: "Dynamic Programming",
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(10, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: complete.id,
  name: "Module 4 Quiz",
  topic: "Dynamic Programming",
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(10, :due),
  submission_method: "Canvas"
})

cs325_mod4_discussion =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: cs325.id,
    type_id: discussion.id,
    status_id: in_progress.id,
    name: "Module 4 Discussion",
    topic: "Dynamic Programming",
    unlock_date: shift_date(-10, :unlock),
    due_date: shift_date(13, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: cs325_mod4_discussion.id,
  name: "Initial Post",
  due_at: shift_date(10, :due),
  completed_at: shift_date(-6, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: cs325_mod4_discussion.id,
  name: "Responses",
  due_at: shift_date(13, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: in_progress.id,
  name: "Assignment 5",
  topic: "Graph Algorithms Part 1",
  is_prioritized: true,
  priority: 4.0,
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(17, :due),
  submission_method: "Canvas",
  notes: "omg, dijkstra's algorithm is so confusing."
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Module 5 Quiz",
  topic: "Graph Algorithms Part 1",
  is_prioritized: true,
  priority: 4.5,
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(17, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Assignment 6",
  topic: "Greedy Technique and Graph Algorithms Part 2",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(24, :due),
  submission_method: "Canvas",
  notes:
    "need to make sure i'm focusing on only what the next decision is, not any of the previous decisions were or any of the future ones should be."
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Module 6 Quiz",
  topic: "Greedy Technique and Graph Algorithms Part 2",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(24, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Assignment 7",
  topic: "Backtracking",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(31, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Assignment 8",
  topic: "Complexity Classes and NP Completeness Proof",
  unlock_date: shift_date(18, :unlock),
  due_date: shift_date(38, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Module 8 Quiz",
  topic: "Complexity Classes and NP Completeness Proof",
  unlock_date: shift_date(18, :unlock),
  due_date: shift_date(38, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Assignment 9",
  topic: "Heuristic Algorithms",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(45, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Module 9 Quiz",
  topic: "Heuristic Algorithms",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(45, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: exam.id,
  status_id: not_started.id,
  name: "Mock Interview",
  topic: "Mock Interview",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(43, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: cs325.id,
  type_id: exam.id,
  status_id: not_started.id,
  name: "Final Exam",
  topic: "Cumulative",
  unlock_date: shift_date(32, :unlock),
  due_date: shift_date(50, :due),
  submission_method: "Canvas"
})

# =============================================================================
# BA 260 ASSIGNMENTS
# =============================================================================

ba260_d1_wk1 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 1 Discussion 1",
    topic: "Show and Tell & Self-Introductions",
    unlock_date: shift_date(-24, :unlock),
    due_date: shift_date(-13, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk1.id,
  name: "Initial Post",
  due_at: shift_date(-15, :due),
  completed_at: shift_date(-20, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk1.id,
  name: "Responses",
  due_at: shift_date(-13, :due),
  completed_at: shift_date(-17, :now),
  order: 2
})

ba260_d2_wk1 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 1 Discussion 2",
    topic: "EM - Drawing and Discussion",
    unlock_date: shift_date(-24, :unlock),
    due_date: shift_date(-13, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk1.id,
  name: "Initial Post",
  due_at: shift_date(-15, :due),
  completed_at: shift_date(-19, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk1.id,
  name: "Responses",
  due_at: shift_date(-13, :due),
  completed_at: shift_date(-16, :now),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Wk 1 Assignment 1",
  topic: "Big 5 Personality Test",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Wk 1 Assignment 2",
  topic: "Individual Entrepreneurial Characteristics Survey",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Research Participation",
  topic: "Unknown",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-13, :due),
  submission_method: "Canvas"
})

ba260_d1_wk2 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 2 Discussion 1",
    topic: "AI - A New Team Member?",
    unlock_date: shift_date(-24, :unlock),
    due_date: shift_date(-6, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk2.id,
  name: "Initial Post",
  due_at: shift_date(-8, :due),
  completed_at: shift_date(-12, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk2.id,
  name: "Responses",
  due_at: shift_date(-6, :due),
  completed_at: shift_date(-8, :now),
  order: 2
})

ba260_d2_wk2 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 2 Discussion 2",
    topic: "The Do's and Don'ts of Effective Teamwork",
    unlock_date: shift_date(-24, :unlock),
    due_date: shift_date(-6, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk2.id,
  name: "Initial Post",
  due_at: shift_date(-8, :due),
  completed_at: shift_date(-12, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk2.id,
  name: "Responses",
  due_at: shift_date(-6, :due),
  completed_at: shift_date(-8, :now),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Wk 2 Assignment 1",
  topic: "Team MOU",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-6, :due),
  submission_method: "Canvas"
})

ba260_d1_wk3 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 3 Discussion 1",
    topic: "Connecting Reading and Your Job to Be Done",
    unlock_date: shift_date(-17, :unlock),
    due_date: shift_date(1, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk3.id,
  name: "Initial Post",
  due_at: shift_date(-1, :due),
  completed_at: shift_date(-3, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk3.id,
  name: "Responses",
  due_at: shift_date(1, :due),
  completed_at: shift_date(-1, :now),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: quiz.id,
  status_id: complete.id,
  name: "Wk 3 Quiz 1",
  topic: "Brainstorming Business Idea as Customer Problem",
  unlock_date: shift_date(-17, :unlock),
  due_date: shift_date(-1, :due),
  submission_method: "Canvas"
})

ba260_d2_wk3 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: complete.id,
    name: "Wk 3 Discussion 2",
    topic: "Record Invest Select Customer Problem",
    unlock_date: shift_date(-17, :unlock),
    due_date: shift_date(1, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk3.id,
  name: "Initial Post",
  due_at: shift_date(0, :due),
  completed_at: shift_date(-2, :now),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk3.id,
  name: "Responses",
  due_at: shift_date(1, :due),
  completed_at: shift_date(0, :now),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Wk 3 Assignment 1",
  topic: "Self Reflection",
  unlock_date: shift_date(-17, :unlock),
  due_date: shift_date(3, :due),
  submission_method: "Canvas"
})

ba260_d1_wk4 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 4 Discussion 1",
    topic: "Connecting OEF and Real Life",
    is_prioritized: true,
    priority: 2.0,
    unlock_date: shift_date(-10, :unlock),
    due_date: shift_date(8, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk4.id,
  name: "Initial Post",
  due_at: shift_date(6, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk4.id,
  name: "Responses",
  due_at: shift_date(8, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Wk 4 Quiz 1",
  topic: "Brainstorming Business Ideas Solution Space",
  is_prioritized: true,
  priority: 3.0,
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(6, :due),
  submission_method: "Canvas"
})

ba260_d2_wk4 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: in_progress.id,
    name: "Wk 4 Discussion 2",
    topic: "Record Invest Select Customer Solution",
    is_prioritized: true,
    priority: 2.5,
    unlock_date: shift_date(-10, :unlock),
    due_date: shift_date(8, :due),
    submission_method: "Canvas",
    notes:
      "need to get everybody to post responses in time to adjust the final product that's going to be shown to the class."
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk4.id,
  name: "Initial Post",
  due_at: shift_date(6, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk4.id,
  name: "Responses",
  due_at: shift_date(8, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 4 Assignment 1",
  topic: "Self Reflection",
  is_prioritized: true,
  priority: 3.5,
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(10, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 4 Assignment 2",
  topic: "Team Reflection - I Like I Wish What If",
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(10, :due),
  submission_method: "Canvas"
})

ba260_wk45_a3 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: homework.id,
    status_id: not_started.id,
    name: "Wk 4-5 Assignment 3",
    topic: "Team Solution",
    unlock_date: shift_date(-10, :unlock),
    due_date: shift_date(13, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_wk45_a3.id,
  name: "Initial Post",
  due_at: shift_date(11, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_wk45_a3.id,
  name: "Responses",
  due_at: shift_date(13, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 5 Assignment 1",
  topic: "VentureBlocks Simulation",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 5 Assignment 2",
  topic: "Customer Discovery Interview Template",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(11, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 5 Assignment 3",
  topic: "Customer Discovery Interview and Individual Summary",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(13, :due),
  submission_method: "Canvas"
})

ba260_d1_wk5 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 5 Discussion 1",
    topic: "Discussion",
    unlock_date: shift_date(-3, :unlock),
    due_date: shift_date(15, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk5.id,
  name: "Initial Post",
  due_at: shift_date(13, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk5.id,
  name: "Responses",
  due_at: shift_date(15, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 5 Assignment 4",
  topic: "Self Reflection",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(17, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 5 Assignment 5",
  topic: "Peer Review #1",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(17, :due),
  submission_method: "Canvas"
})

ba260_d1_wk6 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 6 Discussion 1",
    topic: "Prototype with Design Thinking",
    unlock_date: shift_date(4, :unlock),
    due_date: shift_date(22, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk6.id,
  name: "Prototype Choices",
  due_at: shift_date(22, :due),
  order: 1
})

ba260_d2_wk6 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 6 Discussion 2",
    topic: "Share Prototype and Feedback",
    unlock_date: shift_date(4, :unlock),
    due_date: shift_date(22, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk6.id,
  name: "Initial Post",
  due_at: shift_date(20, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk6.id,
  name: "Responses",
  due_at: shift_date(22, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: discussion.id,
  status_id: not_started.id,
  name: "Wk 6 Discussion 3",
  topic: "Team Prototype Feedback Summary and Iteration",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(24, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 6 Assignment 1",
  topic: "Self Reflection",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(24, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 6 Assignment 2",
  topic: "Team Reflection - I Like I Wish What If",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(24, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: quiz.id,
  status_id: not_started.id,
  name: "Wk 7 Quiz 1",
  topic: "Business Model Canvas Updated",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(27, :due),
  submission_method: "Canvas"
})

ba260_d1_wk7 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 7 Discussion 1",
    topic: "Record Invest Select a Business Model",
    unlock_date: shift_date(11, :unlock),
    due_date: shift_date(29, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk7.id,
  name: "Posts + Video",
  due_at: shift_date(27, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk7.id,
  name: "Team Due",
  due_at: shift_date(29, :due),
  order: 2
})

ba260_d2_wk7 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 7 Discussion 2",
    topic: "Business Model Canvas Peer Review",
    unlock_date: shift_date(11, :unlock),
    due_date: shift_date(31, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk7.id,
  name: "Initial Post",
  due_at: shift_date(29, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk7.id,
  name: "Responses",
  due_at: shift_date(31, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: discussion.id,
  status_id: not_started.id,
  name: "Wk 7 Discussion 3",
  topic: "Team Business Model Summary and Iteration",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(31, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 7 Assignment 1",
  topic: "Self Reflection",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(31, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 7 Assignment 2",
  topic: "Team Member Exchange Survey",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(21, :due),
  submission_method: "Canvas"
})

ba260_wk8_a1 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: homework.id,
    status_id: not_started.id,
    name: "Wk 8 Assignment 1",
    topic: "Survey of Willingness to Pay in Qualtrics",
    unlock_date: shift_date(18, :unlock),
    due_date: shift_date(38, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_wk8_a1.id,
  name: "Submit Survey Questions",
  due_at: shift_date(34, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_wk8_a1.id,
  name: "Final Submission",
  due_at: shift_date(38, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 8 Assignment 2",
  topic: "Solution Pricing Strategy",
  unlock_date: shift_date(18, :unlock),
  due_date: shift_date(38, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 8 Assignment 3",
  topic: "Self Reflection",
  unlock_date: shift_date(18, :unlock),
  due_date: shift_date(38, :due),
  submission_method: "Canvas"
})

ba260_d1_wk9 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 9 Discussion 1",
    topic: "HACE OhmConnect",
    unlock_date: shift_date(25, :unlock),
    due_date: shift_date(43, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk9.id,
  name: "Initial Post",
  due_at: shift_date(41, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk9.id,
  name: "Responses",
  due_at: shift_date(43, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 9 Assignment 1",
  topic: "TAM-SAM-SOM",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(45, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 9 Assignment 2",
  topic: "Team Reflection - I Like I Wish What If",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(45, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 9 Assignment 3",
  topic: "Self Reflection",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(45, :due),
  submission_method: "Canvas"
})

ba260_d1_wk10 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 10 Discussion 1",
    topic: "Elevator Pitch Analysis and Discussion Board",
    unlock_date: shift_date(32, :unlock),
    due_date: shift_date(48, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk10.id,
  name: "Initial Post",
  due_at: shift_date(46, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d1_wk10.id,
  name: "Responses",
  due_at: shift_date(48, :due),
  order: 2
})

ba260_d2_wk10 =
  Repo.insert!(%Assignment{
    user_id: user.id,
    school_id: osu.id,
    term_id: spring_26.id,
    course_id: ba260.id,
    type_id: discussion.id,
    status_id: not_started.id,
    name: "Wk 10 Discussion 2",
    topic: "Business Pitch",
    unlock_date: shift_date(32, :unlock),
    due_date: shift_date(50, :due),
    submission_method: "Canvas"
  })

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk10.id,
  name: "Initial Post",
  due_at: shift_date(48, :due),
  order: 1
})

Repo.insert!(%Step{
  user_id: user.id,
  assignment_id: ba260_d2_wk10.id,
  name: "Responses",
  due_at: shift_date(50, :due),
  order: 2
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 10 Assignment 1",
  topic: "Business Pitch Peer Feedback",
  unlock_date: shift_date(32, :unlock),
  due_date: shift_date(50, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Wk 10 Assignment 2",
  topic: "Peer Review #2",
  unlock_date: shift_date(32, :unlock),
  due_date: shift_date(50, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: exam.id,
  status_id: not_started.id,
  name: "Wk 11 Final Exam",
  topic: "Final Exam",
  unlock_date: shift_date(39, :unlock),
  due_date: shift_date(52, :due),
  submission_method: "Canvas"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: ba260.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Extra Credit Final Survey",
  topic: "Extra Credit Survey",
  unlock_date: shift_date(39, :unlock),
  due_date: shift_date(52, :due),
  submission_method: "Canvas"
})

# =============================================================================
# ECON 201Z - SMARTBOOK ASSIGNMENTS
# =============================================================================

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 1 & 2 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(-24, :unlock),
  due_date: shift_date(-17, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 3 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(-17, :unlock),
  due_date: shift_date(-10, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 4 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(-10, :unlock),
  due_date: shift_date(-3, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 5 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(-3, :unlock),
  due_date: shift_date(4, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: in_progress.id,
  name: "Chapter 6 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(4, :unlock),
  due_date: shift_date(11, :due),
  submission_method: "McGraw Hill Connect",
  notes:
    "triangle of consequence = equilibrium to new cross, then drop or raise to opposite curve."
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 18 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(11, :unlock),
  due_date: shift_date(18, :due),
  submission_method: "McGraw Hill Connect",
  notes: "the romans they go the outs"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 12 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(18, :unlock),
  due_date: shift_date(25, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 13 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(25, :unlock),
  due_date: shift_date(32, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 14 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(32, :unlock),
  due_date: shift_date(39, :due),
  submission_method: "McGraw Hill Connect",
  notes: "not a fan of econ sometimes... a lot of the time... most of the time... all of time."
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 16 SmartBook",
  topic: "SmartBook",
  unlock_date: shift_date(39, :unlock),
  due_date: shift_date(46, :due),
  submission_method: "McGraw Hill Connect"
})

# =============================================================================
# ECON 201Z - HOMEWORK ASSIGNMENTS
# =============================================================================

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 1 & 2 Homework",
  topic: "Homework",
  unlock_date: shift_date(-21, :unlock),
  due_date: shift_date(-14, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: complete.id,
  name: "Chapter 3 Homework",
  topic: "Homework",
  unlock_date: shift_date(-14, :unlock),
  due_date: shift_date(-7, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: in_progress.id,
  name: "Chapter 4 Homework",
  topic: "Homework",
  is_prioritized: true,
  priority: 1.0,
  unlock_date: shift_date(-7, :unlock),
  due_date: shift_date(0, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 5 Homework",
  topic: "Homework",
  unlock_date: shift_date(0, :unlock),
  due_date: shift_date(7, :due),
  submission_method: "McGraw Hill Connect",
  notes: "thank god it's just triangle areas."
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: in_progress.id,
  name: "Chapter 6 Homework",
  topic: "Homework",
  unlock_date: shift_date(7, :unlock),
  due_date: shift_date(14, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 18 Homework",
  topic: "Homework",
  unlock_date: shift_date(14, :unlock),
  due_date: shift_date(21, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 12 Homework",
  topic: "Homework",
  unlock_date: shift_date(21, :unlock),
  due_date: shift_date(28, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 13 Homework",
  topic: "Homework",
  unlock_date: shift_date(28, :unlock),
  due_date: shift_date(35, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 14 Homework",
  topic: "Homework",
  unlock_date: shift_date(35, :unlock),
  due_date: shift_date(42, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: homework.id,
  status_id: not_started.id,
  name: "Chapter 16 Homework",
  topic: "Homework",
  unlock_date: shift_date(42, :unlock),
  due_date: shift_date(49, :due),
  submission_method: "McGraw Hill Connect"
})

# =============================================================================
# ECON 201Z - EXAMS
# =============================================================================

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: exam.id,
  status_id: complete.id,
  name: "Exam 1",
  topic: "Chapters 1, 2, 3, 4",
  unlock_date: shift_date(-6, :unlock),
  due_date: shift_date(-2, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: exam.id,
  status_id: not_started.id,
  name: "Exam 2",
  topic: "Chapters 5, 6, 18",
  unlock_date: shift_date(12, :unlock),
  due_date: shift_date(16, :due),
  submission_method: "McGraw Hill Connect"
})

Repo.insert!(%Assignment{
  user_id: user.id,
  school_id: osu.id,
  term_id: spring_26.id,
  course_id: econ.id,
  type_id: exam.id,
  status_id: not_started.id,
  name: "Exam 3",
  topic: "Chapters 12, 13, 14, 16",
  unlock_date: shift_date(40, :unlock),
  due_date: shift_date(44, :due),
  submission_method: "McGraw Hill Connect"
})

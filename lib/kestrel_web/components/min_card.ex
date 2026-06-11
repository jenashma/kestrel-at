defmodule KestrelWeb.MinCard do
  use Phoenix.LiveComponent

  import Kestrel.Formatters

  @doc """
  Renders a card for each assignment that includes minimal detail for prioritization.

  ## Assigns

    - `:assignment` - A map containing assignment data as returned by `Assignments.list_assignments/1`.
    - `:user_time_zone` - The user's time zone string for date formatting.
    - :connected` - A boolean value indicating whether the LiveView WebSocket is connected.
  """
  def render(assigns) do
    ~H"""
    <div class="min_card">
      <div class="data">
        <p class="assignment_name">{@assignment.name}</p>
        
        <p class="due_date">
          {"Due: #{if @connected, do: format_date(@assignment.due_date, @user_time_zone), else: ""}"}
        </p>
        
        <div class="code_and_steps">
          <p class="course_code">{@assignment.course_code}</p>
          
          <p class="steps">
            {"#{format_steps(@assignment.completed_step_count, @assignment.step_count)} #{if @assignment.step_count > 0, do: "steps complete", else: ""}"}
          </p>
        </div>
        
        <p class="notes">{@assignment.notes}</p>
      </div>
      
      <div class="pills">
        <p class="status">{@assignment.status_name}</p>
        
        <p class="type">{@assignment.type_name}</p>
      </div>
    </div>
    """
  end
end

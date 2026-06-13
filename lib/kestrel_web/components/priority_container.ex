defmodule KestrelWeb.PriorityContainer do
  use Phoenix.LiveComponent

  alias KestrelWeb.MinCard

  @doc """
  Renders a container for each assignment priority group. If `%Assignment{is_priority => true}`, then the group is determined by the integer in `%Assignment{priority: priority}`. If `%Assignment{is_priority => false}`, priority is determined by the default sort: due_date -> course_code -> name.

  ## Assigns

    - `:priority_group` - A list of assignments returned by the sort.
    - `:user_time_zone` - The user's time zone string for date formatting.
    - :connected` - A boolean value indicating whether the LiveView WebSocket is connected.
  """
  def render(assigns) do
    ~H"""
    <div class="priority_container">
      <div id="available_now_list">
        <.live_component
          :for={a <- @assignment_list}
          id={a.id}
          module={MinCard}
          assignment={a}
          connected={@connected}
          user_time_zone={@user_time_zone}
        />
      </div>
    </div>
    """
  end
end

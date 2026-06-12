defmodule KestrelWeb.AssignmentsLive.Index do
  @moduledoc """
  LiveView module for the /assignments page.
  """

  use KestrelWeb, :live_view

  alias Kestrel.Assignments
  alias KestrelWeb.PriorityContainer

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    assignments = Assignments.list_assignments(user)
    now = DateTime.utc_now()

    {available_by_priority, available_by_due_date} =
      Assignments.filter_assignments(:available, assignments, now)

    upcoming = Assignments.filter_assignments(:upcoming, assignments, now)
    completed = Assignments.filter_assignments(:completed, assignments, now)

    # The user's time zone according to their params.
    user_time_zone = get_connect_params(socket)["time_zone"] || "UTC"

    socket =
      socket
      |> assign(:available_by_priority, available_by_priority)
      |> assign(:available_by_due_date, available_by_due_date)
      |> assign(:upcoming, upcoming)
      |> assign(:completed, completed)
      |> assign(:connected, connected?(socket))
      |> assign(:user_time_zone, user_time_zone)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="assignment_list">
      <h2>Available Now</h2>
      
      <div id="priority_container_list">
        <%= for {id, assignment_list} <- @available_by_priority do %>
          <.live_component
            id={id}
            module={PriorityContainer}
            assignment_list={assignment_list}
            connected={@connected}
            user_time_zone={@user_time_zone}
          />
        <% end %>
      </div>
      
      <div id="priority_container_list">
        <%= for {id, assignment_list} <- @available_by_due_date do %>
          <.live_component
            id={id}
            module={PriorityContainer}
            assignment_list={assignment_list}
            connected={@connected}
            user_time_zone={@user_time_zone}
          />
        <% end %>
      </div>
      
      <h2>Upcoming</h2>
      
      <div id="upcoming_list">
        <%= for {id, assignment_list} <- @upcoming do %>
          <.live_component
            id={id}
            module={PriorityContainer}
            assignment_list={assignment_list}
            connected={@connected}
            user_time_zone={@user_time_zone}
          />
        <% end %>
      </div>
      
      <h2>Completed</h2>
      
      <div id="completed_list">
        <%= for {id, assignment_list} <- @completed do %>
          <.live_component
            id={id}
            module={PriorityContainer}
            assignment_list={assignment_list}
            connected={@connected}
            user_time_zone={@user_time_zone}
          />
        <% end %>
      </div>
    </div>
    """
  end
end

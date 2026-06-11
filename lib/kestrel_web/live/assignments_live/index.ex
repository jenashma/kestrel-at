defmodule KestrelWeb.AssignmentsLive.Index do
  @moduledoc """
  LiveView module for the /assignments page.
  """

  use KestrelWeb, :live_view

  alias Kestrel.Assignments
  alias KestrelWeb.MinCard

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    assignments = Assignments.list_assignments(user)

    now = DateTime.utc_now()

    upcoming =
      Enum.filter(assignments, fn a ->
        DateTime.compare(a.unlock_date, now) == :gt
      end)

    available =
      Enum.filter(assignments, fn a ->
        DateTime.compare(a.unlock_date, now) != :gt and a.status_name != "Complete"
      end)

    completed =
      Enum.filter(assignments, fn a ->
        a.status_name == "Complete"
      end)

    # The user's time zone according to their params.
    user_time_zone = get_connect_params(socket)["time_zone"] || "UTC"

    socket =
      socket
      |> assign(:upcoming, upcoming)
      |> assign(:available, available)
      |> assign(:completed, completed)
      |> assign(:connected, connected?(socket))
      |> assign(:user_time_zone, user_time_zone)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="assignment_list">
      <h2>Available Now</h2>
      
      <div id="available_now_list">
        <.live_component
          :for={a <- @available}
          id={a.id}
          module={MinCard}
          assignment={a}
          connected={@connected}
          user_time_zone={@user_time_zone}
        />
      </div>
      
      <h2>Upcoming</h2>
      
      <div id="upcoming_list">
        <.live_component
          :for={a <- @upcoming}
          id={a.id}
          module={MinCard}
          assignment={a}
          connected={@connected}
          user_time_zone={@user_time_zone}
        />
      </div>
      
      <h2>Completed</h2>
      
      <div id="completed_list">
        <.live_component
          :for={a <- @completed}
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

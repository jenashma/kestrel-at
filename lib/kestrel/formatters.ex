defmodule Kestrel.Formatters do
  @moduledoc """
  General purpose functions to transform raw data into its final shape.
  """

  @doc """
  Converts a DateTime struct to represent a user's time zone and transforms it into a more human-readable shape.

  ## Example

      iex> Kestrel.Formatters.format_date(~U[2026-01-01 12:34:56Z], "America/Chicago")
      "Due: Thu, Jan 01, 7:34 am"

  """
  @spec format_date(DateTime.t(), String.t()) :: String.t()
  def format_date(date, user_time_zone) do
    date
    |> DateTime.shift_zone!(user_time_zone)
    |> Calendar.strftime("%a, %b %d, %-I:%M %P")
  end

  @doc """
  Formats assignment steps for display on cards. `total_steps` must be a positive integer and `completed_steps` must be a non-negative integer, otherwise an empty string will be returned.

  ## Example

      iex> Kestrel.Formatters.format_steps(2, 5)
      "2/5"
      iex> Kestrel.Formatters.format_steps(0, 0)
      ""
      iex> Kestrel.Formatters.format_steps(3, 0)
      ""
  """
  @spec format_steps(integer(), integer()) :: String.t()
  def format_steps(completed_steps, total_steps) do
    if total_steps > 0 and completed_steps >= 0,
      do: "#{completed_steps}/#{total_steps}",
      else: ""
  end
end

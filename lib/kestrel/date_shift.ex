defmodule DateShift do
  @moduledoc """
  Allows for the shifting of DateTimes based on the current date.
  """

  @doc """
  Shifts time by given number of days. A positive integer returns a future date, while a negative integer returns a past date. Time may be set via date_type to beginning of day by passing :unlock or end of day by passing :due.

  >Date.utc_today() => ~U[2026-01-15]

  >DateShift.shift_date(-5, :unlock) => ~U[2026-01-10 00:00:00]

  >DateShift.shift_date(5, :due) => ~U[2026-01-20 23:59:00]
  """
  @spec shift_date(integer(), atom()) :: %DateTime{}
  def shift_date(number_of_days_to_shift, date_type) do
    {:ok, unlock_datetime} =
      Date.utc_today()
      |> Date.shift(day: number_of_days_to_shift)
      |> make_time(date_type)

    unlock_datetime
  end

  # Creates DateTimes based on PST offset from UTC.
  defp make_time(date, :due) do
    date
    |> Date.shift(day: 1)
    |> DateTime.new(~T[06:59:00])
  end

  defp make_time(date, :unlock) do
    DateTime.new(date, ~T[07:00:00])
  end

  defp make_time(date, :now) do
    DateTime.new(date, ~T[19:34:56])
  end
end

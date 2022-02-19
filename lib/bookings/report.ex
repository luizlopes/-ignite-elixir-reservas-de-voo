defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Agent, as: BookingAgent

  def generate(filename) do
    generate(filename, nil, nil)
  end

  def generate(filename \\ "report.csv", from_date, to_date) do
    create_date_filter(from_date, to_date)
    |> fetch_bookings()
    |> parse_to_csv()
    |> save_on_file(filename)

    {:ok, "Report generated successfully"}
  end

  defp create_date_filter(nil, nil), do: fn _ -> true end

  defp create_date_filter(from_date, to_date) do
    fn element ->
      compare_1 = NaiveDateTime.compare(element.complete_date, from_date)
      compare_2 = NaiveDateTime.compare(element.complete_date, to_date)

      is_equal_or_after_of_from_date = compare_1 == :eq || compare_1 == :gt
      is_equal_or_before_of_to_date = compare_2 == :eq || compare_2 == :lt

      is_equal_or_after_of_from_date && is_equal_or_before_of_to_date
    end
  end

  defp fetch_bookings(filter) do
    BookingAgent.all()
    |> Enum.filter(filter)
  end

  defp parse_to_csv([%Booking{} | _tail] = bookings) do
    Enum.map(bookings, &parse_line/1)
  end

  defp parse_line(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{NaiveDateTime.to_string(complete_date)}\n"
  end

  defp save_on_file(booking_lines, filename) do
    File.write(filename, booking_lines)
  end
end

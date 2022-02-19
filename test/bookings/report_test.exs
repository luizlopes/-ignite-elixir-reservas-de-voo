# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: false

  import Flightex.Factory

  alias Flightex.Bookings.Report

  setup do
    Flightex.start_agents()

    :ok
  end

  describe "generate/1" do
    test "when called, return the content" do
      user_params = build(:user_params)

      {:ok, _user_uuid} = Flightex.Users.CreateOrUpdate.call(user_params)

      params = build(:booking_params)

      Flightex.create_or_update_booking(params)

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate/3" do
    test "when called, return the filtered content" do
      user_params = build(:user_params)

      {:ok, _user_uuid} = Flightex.Users.CreateOrUpdate.call(user_params)

      params_booking_1 = build(:booking_params)

      params_booking_2 =
        build(:booking_params,
          complete_date: ~N[2021-01-07 12:00:00],
          local_origin: "Santo André",
          local_destination: "Maceió"
        )

      params_booking_3 =
        build(:booking_params,
          complete_date: ~N[2021-08-31 12:00:00],
          local_origin: "Ilhéus",
          local_destination: "Itajuípe"
        )

      Flightex.create_or_update_booking(params_booking_1)
      Flightex.create_or_update_booking(params_booking_2)
      Flightex.create_or_update_booking(params_booking_3)

      Flightex.generate_report(~N[2021-01-01 12:00:00], ~N[2021-12-31 12:00:00])

      line_1 = "12345678900,Ilhéus,Itajuípe,2021-08-31 12:00:00\n"
      line_2 = "12345678900,Santo André,Maceió,2021-01-07 12:00:00\n"

      {:ok, file} = File.read("report.csv.csv")

      assert file =~ line_1
      assert file =~ line_2
    end
  end
end

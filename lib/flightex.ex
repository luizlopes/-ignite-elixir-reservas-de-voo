defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Users.Agent, as: UserAgent

  def start_agents do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end
end

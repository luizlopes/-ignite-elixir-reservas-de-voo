defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, &update(&1, booking))

    {:ok, id}
  end

  defp update(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  def get(id) do
    Agent.get(__MODULE__, &get_booking(&1, id))
  end

  defp get_booking(state, id) do
    case Map.has_key?(state, id) do
      true -> {:ok, Map.get(state, id)}
      false -> {:error, "Booking not found"}
    end
  end

  def all do
    Agent.get(__MODULE__, &Map.values/1)
  end
end

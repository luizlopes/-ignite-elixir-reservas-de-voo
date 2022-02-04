defmodule Flightex.Users.Agent do
  use Agent

  alias Flightex.Users.User

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user) do
    Agent.update(__MODULE__, &update_state(&1, user))

    {:ok, user.id}
  end

  def update_state(state, %User{cpf: cpf, id: id} = user) do
    Map.put(state, cpf, user) |> Map.put(id, user)
  end

  def get(key) do
    Agent.get(__MODULE__, &get_user(&1, key))
  end

  defp get_user(state, key) do
    case Map.get(state, key) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end

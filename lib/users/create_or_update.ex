defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.User
  alias Flightex.Users.Agent, as: UserAgent

  def call(%{
        name: name,
        email: email,
        cpf: cpf
      }) do
    User.build(name, email, cpf)
    |> save_user()
  end

  defp save_user({:ok, user}), do: UserAgent.save(user)
  defp save_user({:error, _message} = error), do: error
end

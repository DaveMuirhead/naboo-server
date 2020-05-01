defmodule Naboo.Factory do
  use ExMachina

  alias Naboo.Accounts.Commands.{RegisterUser}

  def user_factory do
    %{
      email: "kylo@ren.com",
      hashed_password: "kyloren",
      first_name: "Kylo",
      last_name: "Ren"
    }
  end

  def register_user_factory do
    struct(RegisterUser, build(:user))
  end

end

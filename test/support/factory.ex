defmodule Naboo.Factory do
  use ExMachina

  def user_factory do
    %{
      email: "kylo@ren.com",
      hashed_password: "kyloren",
      first_name: "Kylo",
      last_name: "Ren"
    }
  end

end

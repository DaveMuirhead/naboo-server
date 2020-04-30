defmodule Naboo.Factory do
  use ExMachina

  def user_factory do
    %{
      email: "jake@jake.jake",
      hashed_password: "jakejake",
    }
  end

end

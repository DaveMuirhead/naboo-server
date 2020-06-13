defmodule NabooWeb.SessionView do
  use NabooWeb, :view

  alias Naboo.Auth.Guardian

  def render("session.json", assigns) do
#    user = assigns["user"]
#    token = assigns["token"]
#    %{
#      "uuid": user.uuid,
#      "token": token
#    }
%{}
  end

  def render(:"401", _assigns) do
    "Unauthorized"
  end

  def render("empty.json", _assigns) do
    %{}
  end

end

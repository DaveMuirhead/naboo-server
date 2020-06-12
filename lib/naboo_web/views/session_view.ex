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

end

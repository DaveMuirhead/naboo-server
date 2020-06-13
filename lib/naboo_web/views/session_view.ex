defmodule NabooWeb.SessionView do
  use NabooWeb, :view

  alias Naboo.Auth.Guardian

  def render("session.json", assigns) do
    user = assigns["user"]
    %{
      "uuid": user.uuid,
      "message": "Signed in successfully. See Location header for link to profile."
    }
  end

  def render(:"401", _assigns) do
    %{
      "message": "You are not authorized to access this resource."
    }
  end

  def render("inactive.json", _assigns) do
    %{
      "message": "This account has been deactivated. Contact support for assistance in re-activating it."
    }
  end

  def render("empty.json", _assigns) do
    %{}
  end

end

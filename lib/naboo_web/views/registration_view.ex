defmodule NabooWeb.RegistrationView do
  use NabooWeb, :view

  def render("registration.json", %{user: user, secret: secret}) do
    %{
      uuid: user.uuid,
      email: user.email,
      secret: secret
    }
  end

end

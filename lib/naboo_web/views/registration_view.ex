defmodule NabooWeb.RegistrationView do
  use NabooWeb, :view

  def render("registration.json", assigns) do
    user = assigns[:user]
    secret = assigns[:secret]
    %{
      uuid: user.uuid,
      email: user.email,
      secret: secret
    }
  end

end

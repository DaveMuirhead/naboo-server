defmodule NabooWeb.EmailView do
  use NabooWeb, :view

  def render("email_change.json", %{new_email: new_email, secret: secret}) do
    %{
      new_email: new_email,
      secret: secret
    }
  end

end
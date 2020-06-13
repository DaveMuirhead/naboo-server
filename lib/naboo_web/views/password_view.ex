defmodule NabooWeb.PasswordView do
  use NabooWeb, :view

  def render("accepted.json", assigns) do
    %{
      "message": "Request accepted. Submit token provided in email with new password via PATCH /password-resets."
    }
  end

end

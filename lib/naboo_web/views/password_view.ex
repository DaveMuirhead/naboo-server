defmodule NabooWeb.PasswordView do
  use NabooWeb, :view

  def render("accepted.json", assigns) do
    %{
      "message": "Request accepted. Submit {\"secret\":\"\", \"email\":\"\", \"password\":\"\"} via PATCH /password-resets."
    }
  end

end

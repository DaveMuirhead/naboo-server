defmodule NabooWeb.SessionView do
  use NabooWeb, :view

  def render("signed_in.json", %{user: user, token: token}) do
    %{
      status: :ok,
      data: %{
        email: user.email,
        token: token,
        uuiud: user.uuid
      },
      message: "You are successfully logged in. Add this token to Authorization header with a 'Bearer' realm to make authorized requests."
    }
  end

  def render("error.json", %{errors: errors}) do
    %{
      status: :unauthorized,
      errors: errors,
      message: "Invalid email or password"
    }
  end

end

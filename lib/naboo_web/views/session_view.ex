defmodule NabooWeb.SessionView do
  use NabooWeb, :view

  def render("signed_in.json", conn) do
    IO.inspect(conn)
    %{
      status: :ok,
      data: %{
        token: conn.user.jwt,
        email: conn.user.email
      },
      message: "You are successfully logged in! Add this token to Authorization header to make authorized requests."
    }
  end

end

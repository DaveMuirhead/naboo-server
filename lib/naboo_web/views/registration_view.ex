defmodule NabooWeb.RegistrationView do
  use NabooWeb, :view

  def render("success.json", %{user: user}) do
    %{
      status: :ok,
      message: "You have been successfully registered. Now you can sign in using your email and password at /api/sign_in, at which time you will receive a JWT token. Please put the JWT token into Authorization header for all authorized requests.",
      data: %{
        email: user.email,
        first_name: user.first_name,
        hashed_password: user.hashed_password,
        last_name: user.last_name,
        uuid: user.uuid
      }
    }
  end

  def render("error.json", %{status: status, message: message}) do
    %{
      status: status,
      message: message
    }
  end

end

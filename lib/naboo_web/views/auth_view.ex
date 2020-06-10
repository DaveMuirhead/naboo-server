defmodule NabooWeb.AuthView do
  use NabooWeb, :view

  def render("account_created.json", %{user: user, token: token}) do
    %{
      status: :created,
      data: %{
        email: user.email,
        token: token,
        uuid: user.uuid
      },
      message: "Your account was successfully created and you are logged in. Add this token to Authorization header with a 'Bearer' realm to make authorized requests."
    }
  end

  def render("signed_in.json", %{user: user, token: token}) do
    %{
      status: :ok,
      data: %{
        email: user.email,
        token: token,
        uuid: user.uuid
      },
      message: "You are successfully logged in. Add this token to Authorization header with a 'Bearer' realm to make authorized requests."
    }
  end

  def render("request.json", %{callback_url: callback_url}) do
    %{
      status: :ok,
      data: %{
        callback_url: callback_url
      },
      message: "Callback url"
    }
  end

  def render("error.json", %{status: status, message: message}) do
    %{
      status: status,
      message: message
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

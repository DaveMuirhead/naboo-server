defmodule NabooWeb.UserView do
  use NabooWeb, :view

  # NOTE: not passing back token
  def render("user.json", %{user: user}) do
    %{
      account_type: user.account_type,
      active: user.active,
      email: user.email,
      email_verified: user.email_verified,
      full_name: user.full_name,
      picture: user.picture,
      nickname: user.nickname,
      uuid: user.uuid,
    }
  end

  end

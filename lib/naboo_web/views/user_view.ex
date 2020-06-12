defmodule NabooWeb.UserView do
  use NabooWeb, :view

  # NOTE: not passing back token
  def render("user.json", assigns) do
    user = assigns[:user]
    %{
      account_type: user.account_type,
      active: user.active,
      email: user.email,
      email_verified: user.email_verified,
      full_name: user.full_name,
      image_url: user.image_url,
      nickname: user.nickname,
      uuid: user.uuid,
    }
  end

end

defmodule NabooWeb.UserView do
  use NabooWeb, :view
  alias NabooWeb.UserView

  def render("index.json", %{users: users}) do
    %{user: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      account_type: user.account_type,
      email: user.email,
      email_verified: user.email_verified,
      full_name: user.full_name,
      immage_url: user.image_url,
      nickname: user.nickname,
      uuid: user.uuid,
    }
  end

  def render("empty.json", %{user: %{}}) do
    %{}
  end
end

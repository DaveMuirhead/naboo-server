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
    %{uuid: user.uuid,
      email: user.email,
      hashed_password: user.hashed_password,
      first_name: user.first_name,
      last_name: user.last_name}
  end

  def render("empty.json", %{user: %{}}) do
    %{}
  end
end

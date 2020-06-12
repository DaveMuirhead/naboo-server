defmodule NabooWeb.ValidationView do
  use NabooWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

end

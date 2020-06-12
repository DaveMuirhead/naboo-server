defmodule NabooWeb.ErrorView do
  use NabooWeb, :view

  def render(:not_implemented, _assigns) do
    "Not yet implemented"
  end

  def render("401", _assigns) do
    "Unauthorized"
  end

  def render("404", _assigns) do
    "Page not found"
  end

  def render("500", _assigns) do
    "Server internal error"
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

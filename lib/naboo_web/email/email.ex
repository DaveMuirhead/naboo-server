defmodule NabooWeb.Email do
  use Bamboo.Phoenix, view: NabooWeb.EmailView

  import Bamboo.Email
  import Bamboo.Phoenix

  def confirm_registration(conn, user, code) do
    base_email()
    |> to(user.email)
    |> subject("Please Confirm Your Registration")
    |> assign(:conn, conn)
    |> assign(:user, user)
    |> assign(:code, code)
    |> render("registration_confirmation.html")
  end

  def confirm_email_change(conn, user, new_email, code) do
    base_email()
    |> to(new_email)
    |> subject("Please Confirm Your Email Address")
    |> assign(:conn, conn)
    |> assign(:user, user)
    |> assign(:code, code)
    |> render("email_change.html")
  end

  def reset_password(conn, email_address, reset_link) do
    base_email()
    |> to(email_address)
    |> subject("Reset Your Password")
    |> assign(:conn, conn)
    |> assign(:reset_link, reset_link)
    |> render("password_reset.html")
  end

  defp base_email do
    new_email()
    |> from("apps@brsg.io")
#    |> put_text_layout
    |> put_html_layout({NabooWeb.LayoutView, "email.html"})
  end

end

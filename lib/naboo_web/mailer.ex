defmodule NabooWeb.Mailer do
  use Bamboo.Mailer, otp_app: :naboo

  import Bamboo.Email

  def deliver_registration_verification_request(unconfirmed_email, verification_code) do
    # TODO possibly execute this in a GenServer or Task?
    new_email(
      to: "#{unconfirmed_email}",
      from: "apps@brsg.io",
      subject: "Complete Your Registration",
      html_body: "<p>Enter this code to verify your email address and complete your registration for Naboo. This code will expire in 10 minutes:</p><br/><p><strong>#{verification_code}</strong><br/></br><p>This message was sent because your email address was used to create a new account with Naboo. If that wasn’t you, you can ignore this email and the account will not be activated.<p/></br><br/>-- The Naboo Team",
      text_body: "Enter this code to verify your email address and complete your registration for Naboo. This code will expire in 10 minutes: #{verification_code}. This message was sent because your email address was used to create a new account with Naboo. If that wasn’t you, you can ignore this email and the account will not be activated. -- The Naboo Team"
    )
    |> deliver_now()
  end

  def deliver_email_verification_request(unconfirmed_email, verification_code) do
    # TODO possibly execute this in a GenServer or Task?
    new_email(
      to: "#{unconfirmed_email}",
      from: "apps@brsg.io",
      subject: "Email Verification",
      html_body: "<p>Enter this code to finish updating your Naboo email address. This code will expire in 10 minutes:</p><br/><p><strong>#{verification_code}</strong><br/></br><p>This email is in response to a recent email change attempt. If that wasn’t you, please reset your password right away.<p/></br><br/>-- The Naboo Team",
      text_body: "Enter this code to finish signing in to your Naboo account. This code will expire in 10 minutes: #{verification_code}. This email is in response to a recent email change attempt. If that wasn’t you, please reset your password right away. -- The Naboo Team"
    )
    |> deliver_now()
  end

  def deliver_password_reset_request(email, reset_link) do
    # TODO possibly execute this in a GenServer or Task?
    new_email(
      to: "#{email}",
      from: "apps@brsg.io",
      subject: "Email Authentication",
      html_body: "<p>Click link to reset password. This link will expire in 10 minutes:</p><br/><p><strong>#{reset_link}</strong><br/></br><p>This email is in response to an attempt to reset password. If that wasn’t you, please login and change your password right away.<p/></br><br/>-- The Naboo Team",
      text_body: "Click link (or copy into your browser) to reset password. This link will expire in 10 minutes: #{reset_link}. This email is in response to attempt to reset password. If that wasn’t you, please login and change your password right away. -- The Naboo Team"
    )
    |> deliver_now()
  end

end

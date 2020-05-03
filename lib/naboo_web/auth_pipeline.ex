defmodule NabooWeb.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :naboo,
                              module: Naboo.Guardian,
                              error_handler: NabooWeb.AuthErrorHandler

  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"

  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end

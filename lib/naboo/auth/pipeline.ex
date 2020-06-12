defmodule Naboo.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :naboo,
                              module: Naboo.Auth.Guardian,
                              error_handler: Naboo.Auth.ErrorHandler

  # The JWT is stored in a secure, HTTP-only, encrypted cookie on the client
  # so we need to retrieve it from the cookie and place it in the Authorization
  # header for the downstream pipeline
  plug Naboo.Auth.LoadJwtFromCookie

  # If there is an authorization header, restrict it to an access token and validate it
#  plug Guardian.Plug.VerifyHeader, realm: "Bearer", claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader

  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end

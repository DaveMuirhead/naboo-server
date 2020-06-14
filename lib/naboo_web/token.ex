defmodule NabooWeb.Token do

  @secret "Xn2r5u8x!A%D*G-KaPdSgVkYp3s6v9y$"
  @max_age 600 #10 minutes

  def generate_verification_token(expected_data) do
    Phoenix.Token.encrypt(NabooWeb.Endpoint, @secret, expected_data)
  end

  def check_verification_token(token, asserted_data) do
    case Phoenix.Token.decrypt(NabooWeb.Endpoint, @secret, token, max_age: @max_age) do
      {:ok, expected_data} ->
        case (asserted_data == expected_data) do
          true -> {:ok, :matched}
          false -> {:error, :unmatched}
        end
      {:error, :expired} -> {:error, :expired}
      {:error, :invalid} -> {:error, :invalid}
    end
  end

  def decrypt_token(token) do
    case Phoenix.Token.decrypt(NabooWeb.Endpoint, @secret, token, max_age: @max_age) do
      {:ok, data} -> data
      {:error, :expired} -> {:error, :expired}
      {:error, :invalid} -> {:error, :invalid}
    end
  end
end

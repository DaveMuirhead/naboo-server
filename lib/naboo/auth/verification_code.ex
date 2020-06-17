defmodule Naboo.Auth.VerificationCode do
  @moduledoc false

  # generate verification code between 100000 and 999999 (ensure 6 chars)
  def next()  do
    :random.seed(:erlang.now())
    :random.uniform(899999) + 100000
  end

end

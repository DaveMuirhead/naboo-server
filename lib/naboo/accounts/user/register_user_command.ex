defmodule Naboo.Accounts.Commands.RegisterUser do
  defstruct [
    :email,
    :first_name,
    :google_uid,
    :hashed_password,
    :image_url,
    :last_name,
    :password,
    :uuid,
  ]

  use ExConstructor
  use Vex.Struct

  alias Naboo.Auth.Authenticator
  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Validators.{UniqueEmail}

  validates(:uuid, uuid: true)

  validates(:email,
    presence: true,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  validates(:hashed_password, string: true)

  @doc """
  Convert email to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    %RegisterUser{register_user | email: String.downcase(email)}
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%RegisterUser{password: password} = register_user) do
    %RegisterUser{register_user |
      password: nil,
      hashed_password: Authenticator.hash_password(password),
    }
  end

  defimpl Naboo.Support.Middleware.Uniqueness.UniqueFields, for: Naboo.Accounts.Commands.RegisterUser do
    def unique(_command), do: [
      {:email, "has already been taken"},
    ]
  end

end

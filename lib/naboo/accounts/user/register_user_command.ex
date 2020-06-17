defmodule Naboo.Accounts.Commands.RegisterUser do
  defstruct [
    :account_type, #:provider or :seeker
    :email,
    :full_name,
    :hashed_password,
    :picture,
    :nickname,
    :password,
    :uuid
  ]

  use ExConstructor
  use Vex.Struct

  alias Naboo.Auth.Authenticator
  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Support.Validators.{StrongPassword, UniqueEmail}

  validates(:account_type,
    presence: true,
    inclusion: [in: ["provider", "seeker"]]
  )

  validates(:uuid, uuid: true)

  validates(:email,
    presence: [message: "Email must be present."],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "Email must be in the format you@yourco.com"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  validates(:password,
    presence: [message: "Password must be present."],
    by: &StrongPassword.validate/2
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
      hashed_password: Authenticator.hash_password(password),
    }
  end

  defimpl Naboo.Support.Middleware.Uniqueness.UniqueFields, for: Naboo.Accounts.Commands.RegisterUser do
    def unique(_command), do: [
      {:email, "has already been taken"},
    ]
  end

end

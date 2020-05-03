defmodule Naboo.Accounts.Commands.RegisterUser do
  defstruct [
    :uuid,
    :email,
    :password,
    :hashed_password,
  ]

  use ExConstructor
  use Vex.Struct

  alias Naboo.Accounts.Commands.{RegisterUser}
  alias Naboo.Accounts.Validators.{UniqueEmail}

  validates(:uuid, uuid: true)

  validates(:email,
    presence: true,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  validates(:hashed_password, presence: true, string: true)

  @doc """
  Convert email to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    %RegisterUser{register_user | email: String.downcase(email)}
  end

  defimpl Naboo.Support.Middleware.Uniqueness.UniqueFields, for: Naboo.Accounts.Commands.RegisterUser do
    def unique(_command), do: [
      {:email, "has already been taken"},
    ]
  end

end

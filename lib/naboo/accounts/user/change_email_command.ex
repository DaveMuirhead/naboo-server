defmodule Naboo.Accounts.Commands.ChangeEmail do
  defstruct uuid: "", email: ""

  use ExConstructor
  use Vex.Struct

  alias Naboo.Accounts.Commands.ChangeEmail
  alias Naboo.Support.Validators.UniqueEmail

  validates(:uuid, uuid: true)

  validates(:email,
    presence: true,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  def downcase_email(%ChangeEmail{email: email} = command) do
    %ChangeEmail{command | email: String.downcase(email)}
  end

end

defimpl Naboo.Support.Middleware.Uniqueness.UniqueFields, for: Naboo.Accounts.Commands.ChangeEmail do
  def unique(_command), do: [
    {:email, "has already been taken"},
  ]
end

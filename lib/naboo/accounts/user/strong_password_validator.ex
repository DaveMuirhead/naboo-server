defmodule Naboo.Accounts.Validators.StrongPassword do
  use Vex.Validator

  def validate(value, context) do
    with :ok <- is_min_length(value),
         :ok <- has_lowercase_letter(value),
         :ok <- has_uppercase_letter(value),
         :ok <- has_number(value),
         :ok <- has_punctuation(value)
      do
      :ok
    else
      err -> err
    end
  end

  def is_min_length(nil) do
    false
  end

  def is_min_length(password) do
    case String.length(password) >= 8 do
      true -> :ok
      false -> {:error, "Must be at least 8 characters long."}
    end
  end

  def has_lowercase_letter(password) do
    case String.match?(password, ~r/[[:lower:]]+/) do
      true -> :ok
      false -> {:error, "Must include lower case letter."}
    end
  end

  def has_uppercase_letter(password) do
    case String.match?(password, ~r/[[:upper:]]+/) do
      true -> :ok
      false -> {:error, "Must include upper case letter."}
    end
  end

  def has_number(password) do
    case String.match?(password, ~r/[[:digit:]]+/) do
      true -> :ok
      false -> {:error, "Must include number."}
    end
  end

  def has_punctuation(password) do
    case String.match?(password, ~r/[[:punct:]]+/) do
      true -> :ok
      false -> {:error, "Must include special character."}
    end
  end

end

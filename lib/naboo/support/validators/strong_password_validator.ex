defmodule Naboo.Support.Validators.StrongPassword do
  use Vex.Validator

#  "Please choose a stronger password with at least 8 characters, including a minimum of one each of upper and lower case letters, numbers and special characters."

  def validate(value, context) do
    case strong_password(value) do
      true -> :ok
      false -> {:error, "Please choose a stronger password with at least 8 characters, including a minimum of one each of upper and lower case letters, numbers and special characters."}
    end
  end

  def strong_password(nil) do
    false
  end

  def strong_password(password) do
    is_min_length(password) and
    has_lowercase_letter(password) and
    has_uppercase_letter(password) and
    has_number(password) and
    has_punctuation(password)
  end

  def is_min_length(nil) do
    false
  end

  def is_min_length(password) do
    String.length(password) >= 8
  end

  def has_lowercase_letter(password) do
    String.match?(password, ~r/[[:lower:]]+/)
  end

  def has_uppercase_letter(password) do
    String.match?(password, ~r/[[:upper:]]+/)
  end

  def has_number(password) do
    String.match?(password, ~r/[[:digit:]]+/)
  end

  def has_punctuation(password) do
    String.match?(password, ~r/[[:punct:]]+/)
  end

end

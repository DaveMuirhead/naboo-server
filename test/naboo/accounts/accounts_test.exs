defmodule Naboo.AccountsTest do
  use Naboo.DataCase

  alias Naboo.Accounts
  alias Naboo.Accounts.Projections.User

  describe "register user" do

    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert user.email == "kylo@ren.com"
      assert user.hashed_password == "kyloren"
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: ""))

      assert errors == %{email: ["must be present"]}
    end

    @tag :integration
    test "should fail when email already taken and return error" do
      assert {:ok, %User{}} = Accounts.register_user(build(:user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user))

      assert errors == %{email: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical email addresses at same time and return error" do
      1..2
      |> Enum.map(fn x -> Task.async(fn -> Accounts.register_user(build(:user, email: "user#{x}@ren.com")) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when email address format is invalid and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: "invalidemail"))

      assert errors == %{email: ["is invalid"]}
    end

    @tag :integration
    test "should convert email address to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user, email: "DARTH@VADER.COM"))

      assert user.email == "darth@vader.com"
    end

  end

end


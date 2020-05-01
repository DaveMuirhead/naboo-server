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

  end

end


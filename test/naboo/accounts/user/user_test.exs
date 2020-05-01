defmodule Naboo.Accounts.Aggregates.UserTest do
  use Naboo.AggregateCase, aggregate: Naboo.Accounts.Aggregates.User

  alias Naboo.Accounts.Events.UserRegistered

  describe "register user" do

    @tag :unit
    test "should succeed when valid" do
      uuid = UUID.uuid4()
      assert_events build(:register_user, uuid: uuid), [
        %UserRegistered{
          uuid: uuid,
          email: "kylo@ren.com",
          hashed_password: "kyloren",
        }
      ]
    end

  end

end

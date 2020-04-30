defmodule NabooWeb.UserControllerTest do
  use NabooWeb.ConnCase

  import Naboo.Factory

  alias Naboo.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.create_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do

    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post conn, Routes.user_path(conn, :create), user: build(:user)
      json = json_response(conn, 201)["user"]

      assert json == %{
               "email" => "kylo@ren.com",
               "first_name" => "Kylo",
               "hashed_password" => "kyloren",
               "last_name" => "Ren",
               "uuid" => nil
             }
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.user_path(conn, :create), user: build(:user, email: "")
      assert json_response(conn, 422)["errors"] == %{
               "email" => [
                 "can't be blank",
               ]
             }
    end

    @tag :web
    test "should not create user and render errors when email has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)

      # attempt to register the same username
      conn = post conn, Routes.user_path(conn, :create), user: build(:user, email: "kylo@ren.com")
      IO.inspect(conn)

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken",
               ]
             }
    end

  end

end
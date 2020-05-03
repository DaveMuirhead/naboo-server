defmodule NabooWeb.RegistrationControllerTest do
  use NabooWeb.ConnCase

  import Naboo.Factory

  alias Naboo.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.register_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do

    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post conn, Routes.registration_path(conn, :register), user: build(:user)
      IO.inspect(json_response(conn, 201))
      json = json_response(conn, 201)["data"]
      uuid = json["uuid"]
      hashed_password = json["hashed_password"]

      assert json == %{
               "email" => "kylo@ren.com",
               "first_name" => nil,
               "hashed_password" => hashed_password,
               "last_name" => nil,
               "uuid" => uuid
             }
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.registration_path(conn, :register), user: build(:user, email: "")
      assert json_response(conn, 422)["errors"] == %{
               "email" => [
                 "must be present",
               ]
             }
    end

    @tag :web
    test "should not create user and render errors when email has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)

      # attempt to register the same username
      conn = post conn, Routes.registration_path(conn, :register), user: build(:user, email: "kylo@ren.com")

      assert json_response(conn, 422)["errors"] == %{
               "email" => [
                 "has already been taken",
               ]
             }
    end

  end

end
defmodule NabooWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use NabooWeb, :controller

  def call(conn, {:error, %Ueberauth.Auth{} = auth}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NabooWeb.AuthView)
    |> render("error.json", auth: auth)
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NabooWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(NabooWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NabooWeb.ValidationView)
    |> render("error.json", errors: errors)
  end

end

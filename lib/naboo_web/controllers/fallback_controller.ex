defmodule NabooWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use NabooWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    IO.puts("FallbackController.call(conn, {:error, %Ecto.Changeset{} = changeset}) was executed")
    IO.inspect(changeset)
    conn
    |> put_status(:unprocessable_entity)
    |> render(NabooWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    IO.puts("FallbackController.call(conn, {:error, :not_found}) was executed")
    conn
    |> put_status(:not_found)
    |> render(NabooWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :expired}) do
    IO.puts("FallbackController.call(conn, {:error, :expired) was executed")
    conn
    |> put_status(:unauthorized)
    |> render(NabooWeb.ErrorView, :"401")
  end

  def call(conn, {:error, :unauthorized}) do
    IO.puts("FallbackController.call(conn, {:error, :unauthorized}) was executed")
    conn
    |> put_status(:unauthorized)
    |> render(NabooWeb.ErrorView, :"401")
  end

  def call(conn, {:error, :internal_server_error}) do
    IO.puts("FallbackController.call(conn, {:error, :internal_server_error}) was executed")
    conn
    |> put_status(:internal_server_error)
    |> render(NabooWeb.ErrorView, :"500")
  end

  def call(conn, other) do
    IO.puts("FallbackController.call(conn, other) was executed")
    IO.inspect(other)
    conn
    |> put_status(:internal_server_error)
    |> render(NabooWeb.ErrorView, :"500")
  end

end
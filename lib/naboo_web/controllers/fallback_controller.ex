defmodule NabooWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use NabooWeb, :controller

  def call(conn, {:error, :aggregate_execution_failed}) do
    IO.puts("FallbackController.call(conn, {:error, :aggregate_execution_failed}) was executed")
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NabooWeb.ValidationView)
    |> render("error.json", errors: %{})
  end

  def call(conn, {:error, :validation_failure, %{} = errors}) do
    IO.puts("FallbackController.call(conn, {:error, :validation_failure, %{} = errors}) was executed")
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NabooWeb.ValidationView)
    |> render("error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    IO.puts("FallbackController.call(conn, {:error, :not_found}) was executed")
    conn
    |> put_status(:not_found)
    |> put_view(NabooWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :expired}) do
    IO.puts("FallbackController.call(conn, {:error, :expired) was executed")
    conn
    |> put_status(:unauthorized)
    |> put_view(NabooWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :unauthorized}) do
    IO.puts("FallbackController.call(conn, {:error, :unauthorized}) was executed")
    conn
    |> put_status(:unauthorized)
    |> put_view(NabooWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :internal_server_error}) do
    IO.puts("FallbackController.call(conn, {:error, :internal_server_error}) was executed")
    conn
    |> put_status(:internal_server_error)
    |> put_view(NabooWeb.ErrorView)
    |> render(:"500")
  end

end

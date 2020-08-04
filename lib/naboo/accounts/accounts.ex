defmodule Naboo.Accounts do

  import Ecto.Changeset
  alias Naboo.Accounts.Queries.{UserByEmail, UserByUuid}
  alias Naboo.Accounts.User
  alias Naboo.App
#  alias Naboo.AssetStore
  alias Naboo.Avatar
  alias Naboo.Repo

  # ################################################################################
  # Commands
  # ################################################################################

  def start_registration(attrs \\ %{}) do
    %User{}
    |> User.start_registration_changeset(attrs)
    |> Repo.insert()
  end

  def complete_registration(%User{} = user, attrs \\ %{}) do
    user
    |> User.complete_registration_changeset(attrs)
    |> Repo.update()
  end

  def update_user(%User{} = user, attrs \\ %{}) do
    changeset = User.update_changeset(user, attrs)
    if changeset.valid? do
      case store_avatar(changeset, user, attrs) do
        {:ok, changeset} ->
          Repo.update(changeset)
        {:error, message} ->
          changeset
          |> add_error(:image, message, [])
          |> apply_action(:update)
      end
    else
      changeset
      |> apply_action(:update)
    end
  end

#  defp store_avatar(changeset, user, %{"avatar" => image_base64} = attrs \\ %{}) do
#    user = %{id: user.uuid}
#    case AssetStore.upload_image(image_base64) do
#      {:ok, url} ->
#        changeset = Ecto.Changeset.put_change(changeset, :avatar_url, url)
#        {:ok, changeset}
#      _ ->
#        {:error, "error storing picture"}
#    end
#  end

  defp store_avatar(changeset, user, %{"avatar" => upload} = attrs \\ %{}) do
    user = %{uuid: user.uuid}
    %Plug.Upload{content_type: content_type, filename: filename, path: path} = upload
    case Avatar.store({%Plug.Upload{filename: filename, path: path}, user}) do
      {:ok, stored_filename} ->
        url = NabooWeb.Endpoint.url <> Avatar.url({"stored_filename", user}, :thumb)
        changeset = Ecto.Changeset.put_change(changeset, :avatar_url, url)
        {:ok, changeset}
      _ ->
        {:error, "error storing picture"}
    end
  end

  defp store_avatar(changeset, user, _) do
    {:ok, changeset}
  end

  def update_password(%User{} = user, %{password: password} = attrs \\ %{}) do
    user
    |> User.password_update_changeset(attrs)
    |> Repo.update()
  end

  def update_email(%User{} = user, %{email: email} = attrs \\ %{}) do
    user
    |> User.email_update_changeset(attrs)
    |> Repo.update()
  end


  # ################################################################################
  # Queries
  # ################################################################################

  def user_by_uuid(uuid) when is_binary(uuid) do
    uuid
    |> String.downcase()
    |> UserByUuid.new()
    |> Repo.one()
  end

  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  # ################################################################################
  # Private
  # ################################################################################

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      found -> {:ok, found}
    end
  end

end

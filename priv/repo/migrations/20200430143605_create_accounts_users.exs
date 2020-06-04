defmodule Naboo.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :uuid, :uuid, primary_key: true
      add :account_type, :string
      add :email, :string
      add :full_name, :string
      add :google_uid, :string
      add :hashed_password, :string
      add :image_url, :string
      add :nickname, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
  end
end

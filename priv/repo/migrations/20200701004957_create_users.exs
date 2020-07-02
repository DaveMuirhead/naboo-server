defmodule Naboo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    create table(:users, primary_key: false) do

      add :uuid, :binary_id, primary_key: true

      add :account_type, :string
      add :active, :boolean
      add :email, :string, null: false
      add :email_verified, :boolean
      add :full_name, :string
      add :password_hash, :string
      add :picture, :string
      add :nickname, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

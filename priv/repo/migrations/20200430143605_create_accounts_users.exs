defmodule Naboo.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :uuid, :uuid, primary_key: true
      add :email, :string
      add :hashed_password, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
  end
end

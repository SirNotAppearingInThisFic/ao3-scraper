defmodule Ao3.Repo.Migrations.AddInitTables do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :name
      add :words, :integer
      add :chapters, :integer
      add :comments, :integer
      add :kudos, :integer
      add :bookmarks, :integer
      add :hits, :integer

      timestamps()
    end

    create table(:users) do
      timestamps()
    end

    create table(:bookmarks) do
      add :user_id, references(:users)
      add :story_id, references(:stories)
    end
  end
end

defmodule Ao3.Repo.Migrations.AddInitTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :username, :string, primary_key: true
      add :bookmarks_fetched_at, :utc_datetime
      timestamps()
    end

    create table(:stories) do
      add :story_id, :integer
      add :type, :integer
      add :author_name, :string
      add :fandoms, {:array, :string}
      add :warnings, {:array, :string}
      add :ships, {:array, :string}
      add :characters, {:array, :string}
      add :tags, {:array, :string}
      add :name, :string
      add :word_count, :integer
      add :chapter_count, :integer
      add :comment_count, :integer
      add :kudos_count, :integer
      add :bookmark_count, :integer
      add :hit_count, :integer
      add :bookmarks_fetched_at, :utc_datetime
      add :story_date, :utc_datetime

      timestamps()
    end

    create table(:bookmarks) do
      add :username, references(:users, column: :username, type: :string)
      add :story_id, references(:stories)
    end
  end
end

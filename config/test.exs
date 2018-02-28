use Mix.Config

config :ao3, Ao3.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ao3_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
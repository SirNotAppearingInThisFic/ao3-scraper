use Mix.Config

config :ao3, Ao3.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ao3_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

use Mix.Config

config :ao3, Ao3.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ao3",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432",
  pool_size: 10
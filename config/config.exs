use Mix.Config

config :ao3, ecto_repos: [Ao3.Repo]

import_config "#{Mix.env()}.exs"

defmodule Ao3.MixProject do
  use Mix.Project

  def project do
    [
      app: :ao3,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      dialyzer: [plt_add_deps: :transitive],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Ao3.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:floki, "~> 0.19.2"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.2.8"},
      {:ecto_enum, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"}
    ]
  end
end

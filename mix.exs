defmodule Twserv.MixProject do
    use Mix.Project

    def project do
    [
        app: :twserv,
        version: "0.1.0",
        elixir: "~> 1.8",
        start_permanent: Mix.env() == :prod,
        deps: deps()
    ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
    [
        extra_applications: [:logger, :cowboy, :plug, :poison, :rethinkdb],
        mod: {Twserv.Application, []}
    ]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
    [
        {:cowboy, "~> 1.0.0"},
        {:plug, "~> 1.5"},
        {:plug_cowboy, "~> 1.0"},
        {:httpoison, "~> 1.4"},
        {:poison, "~> 3.1", override: true},
        {:rethinkdb, git: "https://github.com/hamiltop/rethinkdb-elixir.git", tag: "0.4.0"}
    ]
    end
end

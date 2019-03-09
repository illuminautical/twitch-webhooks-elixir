defmodule Twserv.Application do
    use Application

    def start(_type, _args) do
        # List all child processes to be supervised
        children = [
            Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Twserv.Router, options: [port: 8085])
        ]

        # See https://hexdocs.pm/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: Twserv.Supervisor]
        Supervisor.start_link(children, opts)
    end
end

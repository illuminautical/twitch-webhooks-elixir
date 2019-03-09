defmodule Twserv.Application do
    use Application

    def start(_type, _args) do
        import Supervisor.Spec, warn: false
        children = [
            Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Twserv.Router, options: [port: 8085]),
            worker(Twserv.Database, [Application.get_env(:twserv, :rethink)])
        ]
        opts = [strategy: :one_for_one, name: Twserv.Supervisor]
        Supervisor.start_link(children, opts)
    end
end

defmodule Twserv.Database do
    use RethinkDB.Connection, warn: false
end

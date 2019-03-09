defmodule Twserv.Router do
    use Plug.Router
    use Plug.Debugger
    require Logger
    plug(Plug.Logger, log: :info)
    plug(:match)
    plug(:dispatch)

    get "/" do
        resp = Poison.encode!(%{"hello" => "world"})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, resp)
    end

    match _ do
        send_resp(conn, 404, "not found")
    end
end

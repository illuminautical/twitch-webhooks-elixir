defmodule Twserv.Router do
    use Plug.Router
    use Plug.Debugger
    require Logger
    plug(Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison)
    plug(Plug.Logger, log: :info)
    plug(:match)
    plug(:dispatch)

    get "/" do
        resp = Poison.encode!(%{"hello" => "world"})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, resp)
    end

    get "/test" do
        q = RethinkDB.Query.table("notifications")
            |> RethinkDB.Query.filter(%{webhook: true})
            |> RethinkDB.Query.count()
            |> RethinkDB.run(Twserv.Database)
        resp = Poison.encode!(%{count: q.data})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, resp)
    end

    post "/helix" do
        data = List.first(conn.body_params["data"])
        if data == nil do
            conn |> send_resp(202, "")
        else
            q = RethinkDB.Query.table("notifications")
                |> RethinkDB.Query.filter(%{streamer: data["user_id"]})
                |> RethinkDB.run(Twserv.Database)
            q = q.data
            embed = %{
                title: "**#{data["title"]}**",
                url: "https://twitch.tv/#{data["user_name"]}",
                author: %{
                    name: data["user_name"],
                    url: "https://twitch.tv/#{data["user_name"]}",
                    icon_url: "http://nil.nil/nil.jpeg"
                },
                description: "Playing #{data["game_id"]} for #{data["viewer_count"]} viewers\n[Watch Stream](https://twitch.tv/#{data["user_name"]})",
                thumbnail: %{
                    url: data["thumbnail_url"]
                },
                footer: %{
                    text: "webhooks.twitchbot.io"
                }
            }
            Enum.each(q, fn(notif) ->
                require Logger
                Logger.info("wowee 1")
                IO.puts("wowee 2")
                unless notif["last_stream_id"] == data["stream_id"] do
                    message = %{
                        content: notif["message"],
                        embed: embed
                    }
                    sent = HTTP.Discord.post "/channels/#{notif["channel"]}/messages", Poison.encode!(message)
                    Logger.info(inspect sent)
                    Logger.info("wowee")
                    IO.puts "wowee"
                end
            end)
            #q = RethinkDB.Query.table("notifications")
            #    |> RethinkDB.Query.filter(%{streamer: data["user_id"]})
            #    |> RethinkDB.Query.update(%{last_stream_id: data["stream_id"]}, return_changes: false)
            #    |> RethinkDB.run(Twserv.Database)
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, "{}")
        end
    end

    match _ do
        resp = Poison.encode!(%{"error" => "not found"})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, resp)
    end

    defp bad_request(conn, param) do
        resp = Poison.encode!(%{error: "#{param} parameter is missing or malformed"})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, resp)
    end
end

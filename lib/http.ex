defmodule HTTP.Discord do
    use HTTPoison.Base
    require Logger

    def process_request_url(url) do
        "https://discordapp.com/api/v6" <> url
    end

    def process_request_headers(_headers) do
        [
            {"Content-Type", "application/json"},
            {"User-Agent", "DiscordBot (https://twitchbot.io, v1.0)"},
            {"Authorization", Application.get_env(:twserv, :bot_token)}
        ]
    end
end

defmodule HTTP.Twitch do
    use HTTPoison.Base
    require Logger

    def obtain_access_token() do
        {:ok, resp} = HTTPoison.get(
            "https://id.twitch.tv/oauth2/token",
            params: [
                {"client_id", Application.get_env(:twserv, :twitch_id)},
                {"client_secret", Application.get_env(:twserv, :twitch_secret)},
                {"grant_type", "client_credentials"}
            ]
        )
        if not :ok do
            Logger.error("Failed to obtain access token")
            Logger.error(Poison.encode!(resp))
            nil
        else
            Logger.info("Got access token")
            resp
        end
    end

    def process_request_url(url) do
        "https://api.twitch.tv/helix" <> url
    end

    def process_request_headers(_headers) do
        #access_token = HTTP.Twitch.obtain_access_token()
        [
            {"Content-Type", "application/json"},
            #{"Authorization", "Bearer #{access_token}"},
            {"User-Agent", "DiscordBot (https://twitchbot.io, v1.0)"},
            {"Client-ID", Application.get_env(:twserv, :twitch_id)}
        ]
    end
end

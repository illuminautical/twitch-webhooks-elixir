defmodule HTTP.Discord do
    use HTTPoison.Base
    require Logger

    def process_request_url(url) do
        "https://discordapp.com/api/v6" <> url
    end

    def process_request_headers(_headers) do
        [{"Content-Type", "application/json"}, {"Authorization", Application.get_env(:twserv, :bot_token)}]
    end
end

defmodule PlantGuruWeb.Plug.CSRF do
    import Plug.Conn

    def init(options), do: options

    def call(conn, _opts) do
        requested_with = conn |> get_req_header("x-requested-with")
        origin = conn |> get_req_header("origin")
        is_requested_with = requested_with |> Enum.map(fn value -> value == "XMLHTTPRequest" end) |> Enum.member?(true)
        is_origin = origin |> Enum.map(fn value -> value == "https://plant-guru.com" end) |> Enum.member?(true)
        if(is_requested_with || is_origin) do
            conn
            |> fetch_session
            |> Phoenix.Controller.protect_from_forgery
        else
            conn
        end
    end
end
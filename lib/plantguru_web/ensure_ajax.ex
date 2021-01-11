defmodule PlantGuruWeb.Plug.EnsureAJAX do
    import Plug.Conn

    def init(options), do: options

    def call(conn, _opts) do
        requested_with = conn |> get_req_header("x-requested-with")
        origin = conn |> get_req_header("origin")
        is_requested_with = requested_with |> Enum.map(fn value -> value == "XMLHTTPRequest" end) |> Enum.member?(true)
        # @todo maybe check origin
        if(is_requested_with) do
            conn
        else
            conn
            |> put_status(401)
            |> Phoenix.Controller.put_view(PlantGuruWeb.ErrorView)
            |> Phoenix.Controller.render(:"401", %{})
            |> halt()
        end
    end
end
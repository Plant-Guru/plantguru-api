defmodule PlantGuruWeb.Plug.RequestWith do
    import Plug.Conn
    def init(options), do: options

    def call(conn, _opts) do
        requested_with = conn |> get_req_header("x-requested-with")
        is_requested_with = requested_with |> Enum.empty?()
        case is_requested_with do
            true ->
                conn
                |> put_status(401)
                |> Phoenix.Controller.put_view(PlantGuruWeb.ErrorView)
                |> Phoenix.Controller.render(:"401", %{})
                |> halt()
            false ->
                conn
        end
    end
end
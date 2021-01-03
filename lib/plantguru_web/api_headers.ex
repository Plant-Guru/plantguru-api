defmodule PlantGuruWeb.Plug.APIHeaders do
    import Plug.Conn
  require Logger
    def init(options), do: options
  
    def call(conn, _opts) do
        requested_with = conn |> get_req_header("X-Requested-With")
        Logger.info(request_with)
        case requested_with do
            nil ->
                conn
                |> put_status(:unauthorized)
                |> render(PlantGuruWeb.ErrorView, "auth_required.json")
        end
    end
end
defmodule PlantGuruWeb.API.V1.TokenController do
    use PlantGuruWeb, :controller

    alias Plug.Conn

    @spec get_csrf(Conn.t(), map()) :: Conn.t()
    def get_csrf(conn, _params) do
        conn
        |> json(%{csrf_token: get_csrf_token()})
    end
end
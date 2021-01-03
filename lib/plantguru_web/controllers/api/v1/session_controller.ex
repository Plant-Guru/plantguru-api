defmodule PlantGuruWeb.API.V1.SessionController do
    use PlantGuruWeb, :controller
  
    alias PlantGuruWeb.APIAuthPlug
    alias Plug.Conn
  
    @spec create(Conn.t(), map()) :: Conn.t()
    def create(conn, %{"user" => user_params}) do
        iat = DateTime.utc_now() |> DateTime.to_unix()
        exp = iat + 1_800
        conn
        |> Pow.Plug.authenticate_user(user_params)
        |> case do
            {:ok, conn} ->
                json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token], iat: iat, exp: exp}})
    
            {:error, conn} ->
                conn
                |> put_status(401)
                |> json(%{error: %{status: 401, message: "Invalid email or password"}})
      end
    end
  
    @spec renew(Conn.t(), map()) :: Conn.t()
    def renew(conn, _params) do
        config = Pow.Plug.fetch_config(conn)
        iat = DateTime.utc_now() |> DateTime.to_unix()
        exp = iat + 1_800
        conn
        |> APIAuthPlug.renew(config)
        |> case do
            {conn, nil} ->
                conn
                |> put_status(401)
                |> json(%{error: %{status: 401, message: "Invalid token"}})
    
            {conn, _user} ->
                json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token], iat: iat, exp: exp}})
        end
    end
  
    @spec delete(Conn.t(), map()) :: Conn.t()
    def delete(conn, _params) do
        conn
        |> Pow.Plug.delete()
        |> json(%{data: %{}})
    end
end
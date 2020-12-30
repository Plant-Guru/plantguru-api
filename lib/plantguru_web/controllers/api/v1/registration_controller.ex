defmodule PlantGuruWeb.API.V1.RegistrationController do
    use PlantGuruWeb, :controller
  
    alias Ecto.Changeset
    alias Plug.Conn
    alias PlantGuruWeb.ErrorHelpers
  
    @spec create(Conn.t(), map()) :: Conn.t()
    def create(conn, %{"user" => user_params}) do
        conn
        |> Pow.Plug.create_user(user_params)
        |> case do
            {:ok, user, conn} ->
                send_confirmation_email(user, conn)  # Line Added

                json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})

            {:error, changeset, conn} ->
                errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        
                conn
                |> put_status(500)
                |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
        end
    end


    @doc """
    Sends a confirmation e-mail to the user.

    The user struct passed to the mailer will have the `:email` set to the
    `:unconfirmed_email` value if `:unconfirmed_email` is set.

    *** This is copied and modified from
    ./lib/extensions/email_confirmation/phoenix/controllers/controller_callbacks.ex
    in the 'pow' library.
    REASON: Customize the url sent to include the front-end. ***
    """
    @spec send_confirmation_email(map(), Conn.t()) :: any()
    def send_confirmation_email(user, conn) do
        url = confirmation_url(conn, user)
        unconfirmed_user = %{user | email: user.unconfirmed_email || user.email}
        email = PowEmailConfirmation.Phoenix.Mailer.email_confirmation(conn, unconfirmed_user, url)

        Pow.Phoenix.Mailer.deliver(conn, email)
    end

    defp confirmation_url(conn, user) do
        token = PowEmailConfirmation.Plug.sign_confirmation_token(conn, user)

        Application.get_env(:plantguru, PlantGuruWeb.Endpoint)[:front_end_email_confirm_url]
        |> String.replace("{token}", token)
    end
end
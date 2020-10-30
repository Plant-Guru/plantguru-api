defmodule PlantGuru.Repo do
  use Ecto.Repo,
    otp_app: :plantguru,
    adapter: Ecto.Adapters.Postgres
end

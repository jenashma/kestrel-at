defmodule Kestrel.Repo do
  use Ecto.Repo,
    otp_app: :kestrel,
    adapter: Ecto.Adapters.Postgres
end

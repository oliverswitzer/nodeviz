defmodule Nodeviz.Repo do
  use Ecto.Repo,
    otp_app: :nodeviz,
    adapter: Ecto.Adapters.Postgres
end

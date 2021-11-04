defmodule ImposterArtist.Repo do
  use Ecto.Repo,
    otp_app: :imposter_artist,
    adapter: Ecto.Adapters.Postgres
end

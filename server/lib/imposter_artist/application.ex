defmodule ImposterArtist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Supervisor

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # ImposterArtist.Repo,
      # Start the Telemetry supervisor
      ImposterArtistWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ImposterArtist.PubSub},
      # Start the Endpoint (http/https)
      ImposterArtistWeb.Endpoint,
      {ImposterArtist.GamesSupervisor, []},
      {Registry, [keys: :unique, name: :game_registry]},
      ImposterArtistWeb.Presence,
      worker(ImposterArtistWeb.ChannelWatcher, [:game])

      # Start a worker by calling: ImposterArtist.Worker.start_link(arg)
      # {ImposterArtist.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImposterArtist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImposterArtistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

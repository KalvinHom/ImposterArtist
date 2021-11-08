defmodule ImposterArtist.GamesSupervisor do
  @moduledoc """
  DynamicSupervisor that keeps state of each game room
  """
  alias ImposterArtist.Games.Game
  use DynamicSupervisor

  @registry :game_registry

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def create_game(game) do
    child_specification = {Game, game}
    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl true
  def init(_arg) do
    # :one_for_one strategy: if a child process crashes, only that process is restarted.
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

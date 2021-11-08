defmodule ImposterArtist.Games.Game do
  @moduledoc "Genserver to keep game state"

  use GenServer

  alias ImposterArtist.Games.Game
  @new_game :new
  @in_progress :in_progress
  @completed :completed

  @derive Jason.Encoder
  defstruct host: nil,
            code: nil,
            players: [],
            game_state: @new_game

  @impl true
  def init(game) do
    {:ok, game}
  end

  def add_player(code, user) do
    IO.inspect("add player")

    code
    |> via_tuple()
    |> GenServer.call({:add_player, user})
    |> IO.inspect()
  end

  def stop(process_name, stop_reason) do
    process_name |> via_tuple() |> GenServer.stop(stop_reason)
  end

  @impl true
  def handle_call({:add_player, player}, _from, state) do
    state = Map.update!(state, :players, &[player | &1])
    IO.inspect(state)
    IO.inspect(player)
    {:reply, state, state}
  end

  def handle_call({:remove_player, player}, _from, state) do
    state =
      Map.update!(
        state,
        :players,
        &Enum.reject(&1, fn p -> p["id"] == player["id"] end)
      )

    {:reply, state, state}
  end

  @impl true
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name.code))
  end

  @impl true
  def child_spec(game) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [game]},
      restart: :transient
    }
  end

  defp via_tuple(name),
    do: {:via, Registry, {:game_registry, name}}

  # # Start the server
  # {:ok, pid} = GenServer.start_link(Stack, [:hello])

  # # This is the client
  # GenServer.call(pid, :pop)
  # # => :hello

  # GenServer.cast(pid, {:push, :world})
  # # => :ok

  # GenServer.call(pid, :pop)
  # # => :world
end

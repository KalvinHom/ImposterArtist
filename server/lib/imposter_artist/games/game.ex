defmodule ImposterArtist.Games.Game do
  @moduledoc "Genserver to keep game state"

  use GenServer

  alias ImposterArtist.Games.{Game, WordPacks}
  @new_game :new
  @in_progress :in_progress
  @voting :voting
  @voting_complete :voting_complete
  @completed :completed

  @derive Jason.Encoder
  defstruct host: nil,
            code: nil,
            players: [],
            current_player: nil,
            imposter: nil,
            state: @new_game,
            turn: 0,
            total_rounds: 2,
            round: 0,
            theme: nil,
            word: nil,
            votes: %{}

  @impl true
  def init(game) do
    {:ok, game}
  end

  def get(code) do
    code
    |> via_tuple()
    |> GenServer.call(:get)
  end

  def add_player(code, user) do
    code
    |> via_tuple()
    |> GenServer.call({:add_player, user})
  end

  def remove_player(code, user_id) do
    code
    |> via_tuple()
    |> GenServer.call({:remove_player, user_id})
  end

  def start(code) do
    code
    |> via_tuple()
    |> GenServer.call(:start_game)
  end

  def next_turn(code) do
    code
    |> via_tuple()
    |> GenServer.call(:next_turn)
  end

  def update_game(code, game) do
    code
    |> via_tuple()
    |> GenServer.call({:update_game, game})
  end

  def vote_imposter(code, user, voted_user_id) do
    code
    |> via_tuple()
    |> GenServer.call({:vote_imposter, user, voted_user_id})
  end

  def stop(process_name, stop_reason) do
    process_name |> via_tuple() |> GenServer.stop(stop_reason)
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:start_game, _from, state) do
    players = Enum.shuffle(state.players)
    theme = WordPacks.get_random_theme()
    word = WordPacks.get_random_word(theme)

    state =
      state
      |> Map.put(:state, @in_progress)
      |> Map.put(:current_player, Enum.at(players, 0))
      |> Map.put(:imposter, Enum.random(players))
      |> Map.put(:players, players)
      |> Map.put(:theme, theme)
      |> Map.put(:word, word)
      |> Map.put(:round, 1)
      |> Map.put(:turn, 1)

    {:reply, state, state}
  end

  @impl true
  def handle_call({:add_player, player}, _from, state) do
    state = Map.update!(state, :players, &[player | &1])
    {:reply, state, state}
  end

  def handle_call({:remove_player, user_id}, _from, state) do
    state =
      Map.update!(
        state,
        :players,
        &Enum.reject(&1, fn p -> p["id"] == user_id end)
      )

    state =
      case state.host["id"] == user_id do
        true -> Map.put(state, :host, List.first(state.players))
        _ -> state
      end

    {:reply, state, state}
  end

  def handle_call({:update_game, game}, _from, state) do
    {:reply, game, game}
  end

  def handle_call(:next_turn, _from, state) do
    game =
      state
      |> increment_player
      |> advance_state

    {:reply, game, game}
  end

  def handle_call({:vote_imposter, user, voted_user_id}, _from, state) do
    votes = Map.put(state.votes, user["id"], voted_user_id)

    game =
      Map.put(state, :votes, votes)
      |> advance_state()

    {:reply, game, game}
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

  defp via_tuple(name) do
    {:via, Registry, {:game_registry, name}}
  end

  defp increment_player(game) do
    turn = game.turn + 1

    next_player_idx = rem(turn - 1, Enum.count(game.players))
    next_player = Enum.at(game.players, next_player_idx)

    next_round =
      case next_player_idx do
        0 -> game.round + 1
        _ -> game.round
      end

    total_rounds = game.total_rounds

    next_player =
      case next_round do
        n when n > total_rounds -> nil
        _ -> next_player
      end

    game
    |> Map.put(:turn, turn)
    |> Map.put(:round, next_round)
    |> Map.put(:current_player, next_player)
  end

  defp advance_state(%{round: round, total_rounds: total_rounds, state: @in_progress} = game)
       when round > total_rounds do
    Map.put(game, :state, @voting)
  end

  defp advance_state(%{state: @voting} = game) do
    vote_count =
      game.votes
      |> Map.keys()
      |> Enum.count()

    case vote_count == Enum.count(game.players) do
      true -> Map.put(game, :state, @voting_complete)
      _ -> game
    end
  end

  defp advance_state(game), do: game
end

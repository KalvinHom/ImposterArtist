defmodule ImposterArtist.Games do
  alias ImposterArtist.Games.{CodeGenerator, Game}
  alias ImposterArtist.GamesSupervisor

  @new "new"
  @in_progress "in_progress"

  def create(user) do
    code = CodeGenerator.generate()

    game = %Game{
      host: user,
      code: code,
      players: [],
      state: @new
    }

    {:ok, _pid} = GamesSupervisor.create_game(game)
    game
  end

  def get(code) do
    Game.get(code)
  end

  def join(code, user) do
    Game.add_player(code, user)
  end

  def start(code) do
    Game.start(code)
  end

  def next_turn(code) do
    Game.next_turn(code)
  end

  def vote_imposter(code, user, voted_user_id) do
    Game.vote_imposter(code, user, voted_user_id)
  end

  def leave(code, user_id) do
    game = Game.remove_player(code, user_id)

    case Enum.count(game.players) do
      0 ->
        Game.stop(code, :normal)
        nil

      _ ->
        game
    end
  end
end

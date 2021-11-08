defmodule ImposterArtist.Games do
  alias ImposterArtist.Games.{CodeGenerator, Game}
  alias ImposterArtist.GamesSupervisor

  def create(user) do
    code = CodeGenerator.generate()

    game = %Game{
      host: user,
      code: code,
      players: []
    }

    {:ok, _pid} = GamesSupervisor.create_game(game)
    game
  end

  def join(code, user) do
    IO.inspect("joining")
    Game.add_player(code, user)
  end
end

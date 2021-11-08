defmodule ImposterArtistWeb.GameController do
  use ImposterArtistWeb, :controller
  alias ImposterArtist.Games

  @code_length 6
  def create(conn, %{"user" => user}) do
    game = Games.create(user)
    # notify socket of new game
    json(conn, game)
  end
end

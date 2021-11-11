defmodule ImposterArtistWeb.GameRoomChannel do
  use ImposterArtistWeb, :channel
  alias ImposterArtistWeb.ChannelWatcher
  alias ImposterArtist.Games

  @impl true
  def join("game:" <> code, %{"user" => user}, socket) do
    if authorized?(user) do
      game = Games.join(code, user)
      send(self(), :after_join)

      socket =
        socket
        |> assign(:current_game, code)
        |> assign(:user, user)

      {:ok, game, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def leave(socket, code, user_id) do
    game = Games.leave(code, user_id)
    broadcast_from(socket, "update_game_state", game)
    {:ok, game, socket}
  end

  def handle_info(:after_join, socket) do
    :ok =
      ChannelWatcher.monitor(
        :game,
        self(),
        {__MODULE__, :leave, [socket, socket.assigns.current_game, socket.assigns.user["id"]]}
      )

    broadcast_from(socket, "update_game_state", Games.get(socket.assigns.current_game))
    {:noreply, socket}
  end

  @impl true
  def handle_in("start", payload, socket) do
    game = Games.start(socket.assigns.current_game)
    broadcast(socket, "update_game_state", game)
    {:reply, {:ok, game}, socket}
  end

  def handle_in("update_whiteboard", payload, socket) do
    broadcast_from(socket, "update_game_state", payload)
    {:noreply, socket}
  end

  def handle_in("vote_imposter", payload, socket) do
    game =
      Games.vote_imposter(
        socket.assigns.current_game,
        socket.assigns.user,
        payload["voted_user_id"]
      )

    broadcast(socket, "update_game_state", game)
    {:noreply, socket}
  end

  def handle_in("complete_turn", payload, socket) do
    game = Games.next_turn(socket.assigns.current_game)

    broadcast(socket, "update_game_state", game)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

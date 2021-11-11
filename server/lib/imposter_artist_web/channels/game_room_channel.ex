defmodule ImposterArtistWeb.GameRoomChannel do
  use ImposterArtistWeb, :channel
  alias ImposterArtistWeb.Presence
  alias ImposterArtistWeb.ChannelWatcher
  alias ImposterArtist.Games

  @impl true
  def join("game:" <> code, %{"user" => user}, socket) do
    if authorized?(user) do
      IO.inspect("joining channel")

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

    # {:ok, _} =
    #   Presence.track(
    #     socket,
    #     socket.assigns.user["id"],
    #     socket.assigns.user
    #   )

    # push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_in("start", payload, socket) do
    IO.inspect(Presence.list(socket))
    Games.start(socket.assigns.code)
    {:no_reply, socket}
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

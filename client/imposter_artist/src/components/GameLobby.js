import React, { useEffect, useRef, useContext, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Whiteboard from "./Whiteboard";
import UserContext from "../contexts/UserContext";
import GameStatus from "./GameStatus";
import socket from "../socket";
import "./GameLobby.scss";
import WaitingRoom from "./WaitingRoom";
function GameLobby() {
  const { code } = useParams();
  const channelRef = useRef(null);
  const [user, _] = useContext(UserContext);
  const [game, updateGame] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    return () => {
      channelRef.current && channelRef.current.leave();
    };
  }, []);
  useEffect(() => {
    if (!user) {
      return navigate("/");
    }
    channelRef.current = socket.channel(`game:${code}`, { user: user });

    channelRef.current.join().receive("ok", (payload) => {
      updateGame(payload);
    });

    function updateGameState(data) {
      updateGame(data);
    }

    channelRef.current.on("update_game_state", updateGameState);
  }, [code, user, navigate]);

  if (game && game.state !== "new")
    return (
      <div>
        <GameStatus game={game} user={user} channel={channelRef.current} />
        <Whiteboard game={game} channel={channelRef.current} />
      </div>
    );
  return <WaitingRoom game={game} user={user} channel={channelRef.current} />;
}

export default GameLobby;

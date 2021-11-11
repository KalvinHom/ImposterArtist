import React, { useEffect, useRef, useContext, useState } from "react";
import { Presence } from "phoenix";
import { useParams, useNavigate } from "react-router-dom";
import UserContext from "../contexts/UserContext";
import GameOptions from "./GameOptions";
import socket from "../socket";
import "./GameLobby.scss";
function GameLobby() {
  const { code } = useParams();
  const channelRef = useRef(null);
  const [user, _] = useContext(UserContext);
  const [game, updateGame] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    return () => {
      console.log("leaving");
      channelRef.current.leave();
    };
  }, []);
  useEffect(() => {
    if (!user) {
      return navigate("/");
    }
    channelRef.current = socket.channel(`game:${code}`, { user: user });

    channelRef.current.join().receive("ok", (payload) => {
      console.log(payload);
      updateGame(payload);
    });

    function updateGameState(data) {
      console.log(data);
      updateGame(data);
    }

    channelRef.current.on("update_game_state", updateGameState);
  }, [code, user, navigate]);

  console.log(channelRef.current);
  return (
    <div className="GameLobby">
      <div>
        Game Code:
        <br />
        {code}
      </div>
      <div className="host">
        Host:
        <br />
        {game && game.host.username}
      </div>
      <div className="players">Players:</div>
      {game &&
        game.players.map((player) => {
          console.log(player);
          return <div key={player.id}>{player.username}</div>;
        })}
      <GameOptions game={game} user={user} channel={channelRef.current} />
    </div>
  );
}

export default GameLobby;

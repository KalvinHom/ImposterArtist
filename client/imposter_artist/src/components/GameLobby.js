import React, { useEffect, useRef, useContext, useState } from "react";
import { Presence } from "phoenix";
import { useParams, useNavigate } from "react-router-dom";
import UserContext from "../contexts/UserContext";
import socket from "../socket";
import "./GameLobby.scss";
function GameLobby() {
  const { code } = useParams();
  const channelRef = useRef(null);
  const [user, _] = useContext(UserContext);
  const [game, updateGame] = useState(null);
  const [players, setPlayers] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (!user) {
      return navigate("/");
    }
    channelRef.current = socket.channel(`game:${code}`, { user: user });
    let presence = new Presence(channelRef.current);

    let listBy = (id, { metas: [first, ...rest] }) => {
      return first;
    };
    presence.onSync(() => {
      const players = presence.list(listBy);
      console.log(players);
      setPlayers(players);
    });
    console.log("joining");
    channelRef.current.join().receive("ok", (payload) => {
      console.log(payload);
      updateGame(payload);
    });
    return () => {
      console.log("leaving");
      channelRef.current.push("leave", user);
      channelRef.current.leave();
    };
  }, [code, user, navigate]);

  console.log(players);
  return (
    <div className="GameLobby">
      <div>
        Game Code:
        <br />
        {code}
      </div>
      <div className="players">Players:</div>
      {players &&
        players.map((player) => {
          console.log(player);
          return <div key={player.id}>{player.username}</div>;
        })}
    </div>
  );
}

export default GameLobby;

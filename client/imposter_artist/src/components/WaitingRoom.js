import React from "react";
import GameOptions from "./GameOptions";
import "./WaitingRoom.scss";
function WaitingRoom({ game, user, channel }) {
  return (
    <div className="WaitingRoom">
      <div>
        Game Code:
        <br />
        {game && game.code}
      </div>
      <div className="host">
        Host:
        <br />
        {game && game.host.username}
      </div>
      <div className="players">Players:</div>
      {game &&
        game.players.map((player) => {
          return <div key={player.id}>{player.username}</div>;
        })}
      <GameOptions game={game} user={user} channel={channel} />
    </div>
  );
}

export default WaitingRoom;

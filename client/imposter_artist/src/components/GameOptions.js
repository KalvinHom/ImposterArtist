import React from "react";

function GameOptions({ game, user, channel }) {
  if (
    !game ||
    game.host.id !== user.id ||
    !channel ||
    channel.state !== "joined"
  )
    return null;

  function handleStart() {
    channel.push("start");
  }
  return (
    <div className="GameOptions">
      <button onClick={handleStart}>Start Game</button>
    </div>
  );
}

export default GameOptions;

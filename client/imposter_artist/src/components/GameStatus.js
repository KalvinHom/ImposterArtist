import React from "react";
import Voting from "./Voting";
import VotingComplete from "./VotingComplete";
import "./GameStatus.scss";
function GameStatus({ game, user, channel }) {
  console.log(game);
  console.log(user);
  const word =
    game.imposter.id === user.id
      ? "You are the imposter"
      : `Word: ${game.word}`;

  return (
    <div className="GameStatus">
      <div>Theme: {game.theme}</div>
      <div>{word}</div>
      {game.state === "voting" && <Voting game={game} channel={channel} />}
      {game.state === "voting_complete" && <VotingComplete game={game} />}
    </div>
  );
}

export default GameStatus;

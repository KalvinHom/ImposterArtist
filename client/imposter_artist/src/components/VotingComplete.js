import React from "react";

function VotingComplete({ game }) {
  const voted_map = Object.values(game.votes).reduce((counts, vote) => {
    counts[vote] = (counts[vote] || 0) + 1;
    return counts;
  }, {});
  const most_voted_id = Object.keys(voted_map).reduce((a, b) =>
    voted_map[a] > voted_map[b] ? a : b
  );

  const voted_player = game.players.find((p) => p.id === most_voted_id);

  const result = most_voted_id === game.imposter.id ? "CORRECT" : "INCORRECT";
  return (
    <div>
      {voted_player.username} was voted as the imposter...
      <br />
      That is {result}
    </div>
  );
}

export default VotingComplete;

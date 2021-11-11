import React, { useState } from "react";

function Voting({ game, channel }) {
  const [imposter, setImposter] = useState(null);

  // const voteImposter = useCallback((value) => {
  //   setValue(value);
  //   channel.push("vote_imposter", { uuid: value });
  // });

  function voteImposter(e) {
    setImposter(e.target.value);
    channel.push("vote_imposter", { voted_user_id: e.target.value });
  }
  return (
    <div className="Votng">
      <div>Who is the imposter?</div>
      {game.players.map((player) => {
        const count = Object.values(game.votes).filter(
          (x) => x === player.id
        ).length;
        return (
          <div key={player.id}>
            <input
              type="radio"
              name="imposter"
              value={player.id}
              checked={imposter === player.id}
              onChange={voteImposter}
            />
            {player.username} ({count})
          </div>
        );
      })}
    </div>
  );
}

export default Voting;

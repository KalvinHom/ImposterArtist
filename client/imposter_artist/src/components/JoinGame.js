import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function JoinGame() {
  const [code, setCode] = useState("");
  let navigate = useNavigate();

  function handleChange(e) {
    const code = e.target.value;
    setCode(code);
  }

  function handleSubmit(e) {
    e.preventDefault();
    navigate(`/game/${code}`);
  }
  return (
    <div className="join-game">
      Enter a game room to join an existing a game.
      <input type="text" value={code} onChange={handleChange}></input>
      <button type="submit" onClick={handleSubmit}>
        Join
      </button>
    </div>
  );
}

export default JoinGame;

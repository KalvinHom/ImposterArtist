import React, { useContext } from "react";
import UserContext from "../contexts/UserContext";
import "./UserLobby.scss";

function UserLobby() {
  const [user, _] = useContext(UserContext);
  return (
    <div className="UserLobby">
      <h2>Welcome {user}!</h2>
      <div className="user-options">
        <div className="create-game">
          <button className="create">Create a game</button>
        </div>
        <div className="join-game">
          Enter a game room to join an existing a game.
          <input type="text"></input>
          <button type="submit">Join</button>
        </div>
      </div>
    </div>
  );
}

export default UserLobby;

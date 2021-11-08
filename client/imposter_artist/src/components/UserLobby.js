import React, { useContext } from "react";
import { useNavigate } from "react-router-dom";
import UserContext from "../contexts/UserContext";
import JoinGame from "./JoinGame";
import { create } from "../api/game";

import "./UserLobby.scss";

function UserLobby() {
  const [user, _] = useContext(UserContext);
  let navigate = useNavigate();

  function handleCreate() {
    create({ user }).then(function (response) {
      navigate(`/game/${response.data.code}`);
    });
  }

  return (
    <div className="UserLobby">
      <h2>Welcome {user.username}!</h2>
      <div className="user-options">
        <div className="create-game">
          <button className="create" onClick={handleCreate}>
            Create a game
          </button>
        </div>
        <JoinGame />
      </div>
    </div>
  );
}

export default UserLobby;

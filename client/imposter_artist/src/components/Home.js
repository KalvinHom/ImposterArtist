import React, { useState, useContext } from "react";
import UserContext from "../contexts/UserContext";
import Login from "./Login";
import UserLobby from "./UserLobby";
import "./Home.scss";

function Home() {
  const [user, _setUser] = useContext(UserContext);
  // add more validations

  return <div className="Home">{user ? <UserLobby /> : <Login />}</div>;
}

export default Home;

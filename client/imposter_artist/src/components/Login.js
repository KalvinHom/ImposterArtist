import React, { useState, useContext } from "react";
import { v4 as uuidv4 } from "uuid";

import UserContext from "../contexts/UserContext";
import "./Login.scss";

function Login() {
  const [userInput, setUserInput] = useState("");
  const [error, setError] = useState("");
  const [_user, setUser] = useContext(UserContext);
  // add more validations
  function validate(username) {
    console.log(username);
    return username.trim() !== "";
  }

  function handleChange(e) {
    const userInput = e.target.value;
    setUserInput(userInput);
  }

  function handleSubmit(e) {
    e.preventDefault();
    const error = !validate(userInput);
    if (error) return setError("Invalid username");
    setError(null);
    const newUser = { id: uuidv4(), username: userInput };
    setUser(newUser);
    localStorage.setItem("user", JSON.stringify(newUser));
  }
  return (
    <div className="Login">
      <form className="user-form" onSubmit={handleSubmit}>
        <div className="user-input">
          <input
            type="text"
            autoComplete="off"
            autoCorrect="off"
            autoCapitalize="off"
            spellCheck="false"
            placeholder="Username"
            onChange={handleChange}
          ></input>
          <button className="submit" type="submit">
            Enter
          </button>
          <div className={`error ${error ? "has-error" : ""}`}>{error}</div>
        </div>
      </form>
    </div>
  );
}

export default Login;

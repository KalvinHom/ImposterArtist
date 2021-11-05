import React, { useState, useContext } from "react";
import UserContext from "../contexts/UserContext";
import "./Login.scss";

function Login() {
  const [userInput, setUserInput] = useState("");
  const [error, setError] = useState("");
  const [user, setUser] = useContext(UserContext);
  // add more validations
  function validate(username) {
    return username.trim() != "";
  }

  function handleChange(e) {
    const userInput = e.target.value;
    setUserInput(userInput);
  }

  function handleSubmit(e) {
    e.preventDefault();
    const error = !validate(userInput);
    console.log(error);
    if (error) return setError("Invalid username");
    setError(null);
    setUser(userInput);
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

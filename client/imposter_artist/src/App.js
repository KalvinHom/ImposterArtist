import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Home from "./components/Home";
import GameLobby from "./components/GameLobby";
import UserProvider from "./providers/UserProvider";
import GameProvider from "./providers/GameProvider";
import "./App.scss";

function App() {
  return (
    <div className="App">
      <div className="header">
        <h1>Imposter Artist</h1>
      </div>

      <UserProvider>
        <GameProvider>
          <Router>
            <Routes>
              <Route exact path="/" element={<Home />} />
              <Route path="/game/:code" element={<GameLobby />} />
            </Routes>
          </Router>
        </GameProvider>
      </UserProvider>
    </div>
  );
}

export default App;

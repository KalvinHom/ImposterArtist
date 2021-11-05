import { Socket } from "phoenix";

const url = "ws://localhost:4000";
const socket = new Socket(`${url}/socket`);
socket.connect();
export default socket;

import { Socket } from "phoenix";

const host = process.env.REACT_APP_WS_URL;
const socket = new Socket(`${host}/socket`);
socket.connect();
export default socket;

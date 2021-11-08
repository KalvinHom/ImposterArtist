import axios from "axios";

const url = "http://localhost:4000";

export function create(user) {
  return axios.post(`${url}/api/game`, user);
}

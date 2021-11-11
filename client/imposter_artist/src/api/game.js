import axios from "axios";

const host = process.env.REACT_APP_API_URL;

export function create(user) {
  return axios.post(`${host}/api/game`, user);
}

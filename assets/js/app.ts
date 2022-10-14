// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"
import "phoenix_html"
import * as d3 from "d3";
import userSocket from "./user_socket";

let nodes: {string: number}[] = []

const nodeChannel = userSocket.channel("nodes", {})
nodeChannel.join()
  .receive("ok", resp => { console.log("Joined successfully", nodes = resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })



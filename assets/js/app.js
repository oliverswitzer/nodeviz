// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
/* import "../css/app.css" */
/* import "phoenix_html" */
import userSocket from "./user_socket";
import { createRoot } from "react-dom/client";
import { ForceGraph3D } from "react-force-graph";
import React from "react";
import { App } from "./App";

const nodeChannel = userSocket.channel("nodes", {});
const container = document.querySelector("#container");

if (container) {
  const root = createRoot(container);
  root.render(<App nodeChannel={nodeChannel} />);
}

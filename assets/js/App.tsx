import { Channel } from "phoenix";
import React, { useEffect, useState } from "react";
import { ForceGraph3D } from "react-force-graph";

const graphData = {
  nodes: [
    { id: 1, group: 2 },
    { id: 2, group: 1 },
    { id: 3, group: 1 },
  ],
  links: [{ source: 1, target: 2, value: 5 }],
};

type Node = {
  id: string;
  name: string;
};

export const App = ({ nodeChannel }: { nodeChannel: Channel }) => {
  const [nodes, setNodes] = useState<Node[]>([]);

  useEffect(() => {
    if (nodeChannel) {
      nodeChannel
        .join()
        .receive("ok", (_resp) =>
          nodeChannel.push("get_nodes", {}).receive("ok", (res) => {
            setNodes(res.nodes);
          })
        )
        .receive("error", (resp) => {
          console.log("Unable to join", resp);
        });

      nodeChannel.on("refresh_nodes", (res) => setNodes(res.nodes));
    }
  }, [nodeChannel]);

  /* const graphData = toGraphables(nodes); */

  return (
    <div>
      <ForceGraph3D
        graphData={graphData}
        nodeAutoColorBy="group"
        linkDirectionalParticles="value"
        linkDirectionalParticleSpeed={(d) => 0.001}
      />
      {nodes.map((n) => (
        <div>n.id</div>
      ))}
    </div>
  );
};

function toGraphables(nodes: Node[]) {
  return {
    nodes,
    links: [],
  };
}

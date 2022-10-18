defmodule NodevizWeb.NodeChannel do
  use NodevizWeb, :channel

  alias Nodeviz.NodeMonitor
  alias NodevizWeb.Endpoint

  @channel "nodes"

  def broadcast_node(node_name) do
    Endpoint.broadcast(@channel, "new_node", node_name)
  end

  @impl true
  def join(@channel, _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("get_nodes", _payload, socket) do
    nodes = NodeMonitor.current_nodes()

    {:reply, {:ok, %{nodes: nodes}}, socket}
  end
end

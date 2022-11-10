defmodule NodevizWeb.NodeChannel do
  use NodevizWeb, :channel

  alias Nodeviz.NodeMonitor
  alias NodevizWeb.Endpoint

  require Logger

  @channel "nodes"

  def refresh_nodes(nodes) do
    log("Change in node topology, broadcasting to everyone")

    Endpoint.broadcast(@channel, "refresh_nodes", %{nodes: nodes})
  end

  defp log(msg), do: Logger.info("[#{node()}][#{inspect(__MODULE__)}]: #{msg}")

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

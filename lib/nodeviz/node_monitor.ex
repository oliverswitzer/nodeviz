defmodule Nodeviz.NodeMonitor do
  use GenServer

  require Logger

  # ---- Client

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: NodeMonitor)
  end

  def current_nodes() do
    GenServer.call(NodeMonitor, :current_nodes)
  end

  # ---- Server

  @impl GenServer
  def init(_opts) do
    :ok = :net_kernel.monitor_nodes(true)

    {:ok, %{nodes: %{}}, {:continue, :get_current_nodes}}
  end

  @impl GenServer
  def handle_continue(:get_current_nodes, state) do
    state
    |> Map.put(:nodes, get_current_nodes())
    |> noreply()
  end

  @impl GenServer
  def handle_info({:nodeup, node}, state) do
    Logger.info("[Nodeviz] Connection to #{node} established.")

    NodevizWeb.NodeChannel.broadcast_node(node)

    state
    |> Map.put(:nodes, Map.put(state.nodes, node, %{}))
    |> noreply()
  end

  @impl GenServer
  def handle_info({:nodedown, node}, state) do
    Logger.warn("[Nodeviz] Lost connection to #{node}...")

    %{state | nodes: Map.delete(state.nodes, node)}
    |> noreply()
  end

  @impl GenServer
  def handle_call(:current_nodes, _from, state) do
    Map.get(state, :nodes)
    |> reply(state)
  end

  defp get_current_nodes() do
    Node.list()
  end

  defp reply(reply, state), do: {:reply, reply, state}
  defp noreply(state), do: {:noreply, state}
end


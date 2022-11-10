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

    {:ok, %{nodes: MapSet.new()}, {:continue, :get_current_nodes}}
  end

  @impl GenServer
  def handle_continue(:get_current_nodes, state) do
    state
    |> Map.put(:nodes, get_current_nodes())
    |> noreply()
  end

  @impl GenServer
  def handle_info({:nodeup, node}, state) do
    log("New connection established to node: #{node}...")

    get_current_nodes()
    |> NodevizWeb.NodeChannel.refresh_nodes()

    noreply(state)
  end

  @impl GenServer
  def handle_info({:nodedown, node}, state) do
    log("Lost connection to node: #{node}...")

    get_current_nodes()
    |> NodevizWeb.NodeChannel.refresh_nodes()

    noreply(state)
  end

  @impl GenServer
  def handle_call(:current_nodes, _from, state) do
    get_current_nodes()
    |> reply(state)
  end

  defp get_current_nodes() do
    Node.list()
    |> Enum.with_index()
    |> Enum.map(fn {name, i} -> %{id: i, name: Atom.to_string(name)} end)
  end

  defp log(msg), do: Logger.info("[#{node()}]: #{msg}")
  defp reply(reply, state), do: {:reply, reply, state}
  defp noreply(state), do: {:noreply, state}
end

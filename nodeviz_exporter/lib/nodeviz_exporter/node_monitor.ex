defmodule NodevizExporter.NodeMonitor do
  use GenServer

  @version "0.0.1"

  require Logger

  # ---- Client

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # ---- Server

  @impl GenServer
  def init(_opts) do
    :ok = :net_kernel.monitor_nodes(true)

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info({:nodeup, external_node}, state) do
    log(%{type: "NODE_UP", node: external_node})

    noreply(state)
  end

  @impl GenServer
  def handle_info({:nodedown, external_node}, state) do
    log(%{type: "NODE_DOWN", node: external_node})

    noreply(state)
  end

  defp log(msg) do
    Map.merge(msg, %{version: @version, from_node: node()})
    |> Jason.encode!()
    |> Logger.info()
  end

  defp noreply(state), do: {:noreply, state}
end

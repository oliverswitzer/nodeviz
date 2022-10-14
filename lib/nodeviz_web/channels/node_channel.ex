defmodule NodevizWeb.NodeChannel do
  use NodevizWeb, :channel

  @impl true
  def join("nodes", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("ping", payload, socket) do
    broadcast(socket, "pong", payload)

    {:noreply, socket}
  end
end

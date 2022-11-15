defmodule NodevizWeb.PageController do
  use NodevizWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

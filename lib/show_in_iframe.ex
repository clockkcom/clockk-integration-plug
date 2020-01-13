defmodule ClockkIntegrationPlug.ShowInIFrame do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    Plug.Conn.delete_resp_header(conn, "x-frame-options")
  end
end

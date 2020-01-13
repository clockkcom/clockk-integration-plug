defmodule ClockkIntegrationPlug.FixCSRF do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    # For explanation, see: https://github.com/elixir-plug/plug/issues/487#issuecomment-262462495
    Plug.CSRFProtection.get_csrf_token()
    Plug.Conn.put_session(conn, "_csrf_token", Plug.CSRFProtection.dump_state())
  end
end

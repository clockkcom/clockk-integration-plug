defmodule ClockkIntegrationPlug.ValidateHMAC do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    {their_hmac, resource} =
      case Plug.Conn.get_req_header(conn, "clockk-hmac") do
        [] ->
          # The HMAC wasn't provided as a header (action request)
          case conn.params do
            %{"hmac" => hmac, "resource" => resource} ->
              {hmac, resource}

            _ ->
              # This will fail the HMAC test
              {"", ""}
          end

        [hmac] ->
          # The HMAC is provided as a header (webhook request)
          {hmac, Jason.encode!(conn.body_params)}
      end

    our_hmac =
      :crypto.hmac(
        :sha256,
        Application.get_env(:clockk_integration_plug, :client_secret),
        resource
      )
      |> Base.encode16()
      |> String.downcase()

    status = if our_hmac == their_hmac, do: :ok, else: :invlid_hmac

    if status == :ok do
      conn
    else
      conn
      |> send_resp(:bad_request, "invalid or missing hmac")
      |> halt()
    end
  end
end

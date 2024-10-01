defmodule TimeApp.PingServer do
  use GenServer
  require Logger
  alias TimeApp.ServiceConfig, as: Config

  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @impl true
  def init(%Config{frequency: frequency} = config) do
    schedule_ping(frequency)

    {:ok, config}
  end

  @impl true
  def handle_info(:ping, %Config{protocol: protocol, address: address, port: port, frequency: frequency} = config) do

    send_ping_request(protocol, address, port)
    schedule_ping(frequency)

    {:noreply, config}
  end

  defp schedule_ping(frequency) do
    Process.send_after(self(), :ping, frequency)
  end

  defp send_ping_request(:http, address, _port) do
    send_http(address)
  end

  defp send_ping_request(:tcp, address, port) do
    send_tcp(address, port)
  end

  defp send_http(url) do
    Req.get(url, [retry: false])
    |> decode_http_response(url)
  end

  defp decode_http_response({:ok, %Req.Response{status: 200} = response}, url) do
    Logger.info("Response from #{url} -> *** status: #{response.status}")
  end

  defp decode_http_response({:ok, %Req.Response{status: 500} = response}, url) do
    Logger.info("Response from #{url} -> *** status: #{response.status}")
  end

  defp decode_http_response({:error, _response}, url) do
    Logger.info("Response from #{url} -> status: server error")
  end

  defp send_tcp(host, port) do
    host = if is_binary(host), do: to_charlist(host)
    :gen_tcp.connect(host, port, [:binary, active: false], 5000)
    |> decode_tcp_response(host)
  end

  defp decode_tcp_response({:ok, socket}, host) do
    :gen_tcp.close(socket)
    Logger.info("Response from #{host} -> status: active")
  end

  defp decode_tcp_response({:error, _reason}, host) do
    Logger.info("Response from #{host} -> status: not active")
  end

end

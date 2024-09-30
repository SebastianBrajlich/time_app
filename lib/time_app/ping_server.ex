defmodule TimeApp.PingServer do
  use GenServer
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

  defp schedule_ping(frequency \\ 2000) do
    Process.send_after(self(), :ping, frequency)
  end

  defp send_ping_request(protocol, address, port) do

    case protocol do
       :http -> send_http(address)
       :tcp -> send_tcp(address, port)
       _ ->
        IO.puts("Wrong protocol!")
        exit(1)
    end

  end

  defp send_http(url) do
    Req.get(url)
    |> decode_http_response(url)
  end

  defp decode_http_response({:ok, response}, url) do
    IO.puts("Response from #{url} -> status: #{response.status}")
  end

  defp decode_http_response({:error, response}, url) do
    IO.puts("Response from #{url} -> status: #{response.msg}")
  end

  defp send_tcp(host, port) do
    host = if is_binary(host), do: to_char_list(host)
    :gen_tcp.connect(host, port, [:binary, active: false], 5000)
    |> decode_tcp_response(host)
  end

  defp decode_tcp_response({:ok, socket}, host) do
    :gen_tcp.close(socket)
    IO.puts("Response from #{host} -> status: active")
  end

  defp decode_tcp_response({:error, reason}, host) do
    IO.puts("Response from #{host} -> status: #{reason}")
  end

end

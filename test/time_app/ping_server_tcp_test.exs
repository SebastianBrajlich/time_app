defmodule TimeApp.PingServerTcpTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias TimeApp.PingServer, as: PingServer
  alias TimeApp.ServiceConfig, as: ServiceConfig

  @tcp_port 6000

  setup %{} do
    {:ok, socket} = :gen_tcp.listen(@tcp_port, [:binary, {:active, false}, {:reuseaddr, true}])
    spawn(fn -> loop_acceptor(socket) end)
    :ok
  end

  defp loop_acceptor(server_socket) do
    :gen_tcp.accept(server_socket)
    |> serve_connection()
    loop_acceptor(server_socket)
  end

  defp serve_connection({:ok, client_socket}) do
    :gen_tcp.close(client_socket)
  end

  defp serve_connection({:error, :closed}) do
    exit("TCP connection closed!")
  end

  test "testing tcp for successful pings" do
    config = %ServiceConfig{name: "tcp_test_1", protocol: :tcp, address: "localhost", port: @tcp_port, frequency: 1000}
    logs = capture_log(fn -> PingServer.start_link(config); :timer.sleep(2000) end)
    assert logs =~ "Response from localhost -> status: active"
  end

  test "testing tcp for error pings" do
    config = %ServiceConfig{name: "tcp_test_2", protocol: :tcp, address: "localhost", port: 8000, frequency: 1000}
    logs = capture_log(fn -> PingServer.start_link(config); :timer.sleep(2000) end)
    assert logs =~ "Response from localhost -> status: not active"
  end

end

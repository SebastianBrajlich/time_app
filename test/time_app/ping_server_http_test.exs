defmodule TimeApp.PingServerHttpTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias TimeApp.PingServer, as: PingServer
  alias TimeApp.ServiceConfig, as: ServiceConfig

  setup %{} do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "testing http for successful pings with status code 200", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn -> Plug.Conn.resp(conn, 200, "") end)
    url = endpoint_url(bypass.port)
    config = %ServiceConfig{name: "http_test_1", protocol: :http, address: url, frequency: 1000}
    logs = capture_log(fn -> PingServer.start_link(config); :timer.sleep(2000) end)
    assert logs =~ "Response from #{url} -> *** status: 200"
  end

  test "testing http for successful pings with status code 500", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn -> Plug.Conn.resp(conn, 500, "") end)
    url = endpoint_url(bypass.port)
    config = %ServiceConfig{name: "http_test_2", protocol: :http, address: url, frequency: 1000}
    logs = capture_log(fn -> PingServer.start_link(config); :timer.sleep(2000) end)
    assert logs =~ "Response from #{url} -> *** status: 500"
  end

  test "testing http for error pings", %{bypass: bypass} do
    url = endpoint_url(bypass.port)
    Bypass.down(bypass)
    config = %ServiceConfig{name: "http_test_3", protocol: :http, address: url, frequency: 1000}
    logs = capture_log(fn -> PingServer.start_link(config); :timer.sleep(2000) end)
    assert logs =~ "Response from #{url} -> status: server error"
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"

end

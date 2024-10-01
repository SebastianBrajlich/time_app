defmodule TimeApp.ConfigReader do
  alias TimeApp.ServiceConfig, as: ServiceConfig

  def get_service_config_list() do
    config = Application.get_env(:time_app, :services) || []
    Enum.map(config, &create_service_config/1)
  end

  defp create_service_config({name, protocol, address, port, frequency}) do
    %ServiceConfig{name: name, protocol: protocol, address: address, port: port, frequency: frequency}
  end

end

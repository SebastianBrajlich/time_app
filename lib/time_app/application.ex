defmodule TimeApp.Application do
  use Application
  alias TimeApp.ConfigReader, as: ConfigReader
  alias TimeApp.ServiceConfig, as: Config

  @impl true
  def start(_type, _args) do

    children = create_children()
    opts = [strategy: :one_for_one, name: TimeApp.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp create_children() do
    config = ConfigReader.get_service_config_list()
    Enum.map(config, &create_child_spec/1)
  end

  defp create_child_spec(%Config{name: name} = arg) do
    Supervisor.child_spec({TimeApp.PingServer, arg}, id: name)
  end
end

defmodule TimeApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    case Application.fetch_env(:time_app, :url1) do
      {:ok, url} -> IO.puts("URL: #{url}")
      :error -> IO.puts("Error: URL doesn't exist")
    end



    children = [
      # Starts a worker by calling: TimeApp.Worker.start_link(arg)
      # {TimeApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

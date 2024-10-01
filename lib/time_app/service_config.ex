defmodule TimeApp.ServiceConfig do
  @enforce_keys [:name, :protocol, :address]
  defstruct [name: "", protocol: nil, address: "", port: nil, frequency: 500]
end

import Config

config :time_app,
  services: [{:inext, :tcp, "inext.ltrlabs.eu", 9000, 2000}, {:ltrlabs, :http, "https://ltrlabs.eu", nil, 2000}]

import_config "#{config_env()}.exs"

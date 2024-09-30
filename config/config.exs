import Config

config :time_app,
  url1: "first_url",
  url2: "second_url"

import_config "#{config_env()}.exs"

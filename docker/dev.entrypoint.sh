#!/bin/sh

set -e

# Ensure the app's dependencies are installed
mix deps.get

mix ecto.migrate
elixir --sname "timeapp@$HOSTNAME" --cookie monster -S mix
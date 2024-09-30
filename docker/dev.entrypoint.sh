#!/bin/sh

set -e

# Ensure the app's dependencies are installed
mix deps.get

elixir --sname "timeapp@$HOSTNAME" --cookie monster -S mix
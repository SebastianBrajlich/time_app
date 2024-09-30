alias gm := gen-migration
alias t := test-all

# Start the project in development mode
up scale="1":
    docker compose -f docker/dev.docker-compose.yml up -d --build --scale web={{scale}}

# Stop the project in development mode
down:
    docker compose -f docker/dev.docker-compose.yml down

# Run the project in development mode
run cmd:
    docker compose -f docker/dev.docker-compose.yml run --rm web {{cmd}}

# Connect to the remote iex
remote:
    docker compose -f docker/dev.docker-compose.yml exec -it web ./remote.sh

# Generates migration
gen-migration name:
    docker compose -f docker/dev.docker-compose.yml exec -it web mix ecto.gen.migration {{name}}

# Setup database 
setup-db:
    docker compose -f docker/dev.docker-compose.yml run --rm web mix ecto.setup

# Runs migrations
migrate:
    docker compose -f docker/dev.docker-compose.yml exec -it web mix ecto.migrate

# Rollback the last migration
rollback:
    docker compose -f docker/dev.docker-compose.yml exec -it web mix ecto.rollback

# Execute a command in the container, for example: just exec "mix prepush"
exec cmd:
    docker compose -f docker/dev.docker-compose.yml exec -it web {{cmd}}

# watches the logs of the container
logs:
    docker compose -f docker/dev.docker-compose.yml logs -f web

# Connect to the app container shell
shell:
    docker compose -f docker/dev.docker-compose.yml exec -it web /bin/bash

# Run all tests
test-all:
    docker compose -f docker/dev.docker-compose.yml exec -it web mix test

# Run a specific test inside test/ directory
test file:
    docker compose -f docker/dev.docker-compose.yml exec -it web mix test "/app/test/{{file}}"

# Run an arbitrary docker compose command in the dev context
raw *cmd:
    docker compose -f docker/dev.docker-compose.yml {{cmd}}
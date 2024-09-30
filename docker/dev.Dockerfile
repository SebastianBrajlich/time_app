ARG ELIXIR_VERSION=1.17.0
ARG OTP_VERSION=27.0
ARG UBUNTU_VERSION=jammy-20240530
ARG MIX_ENV=dev

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-ubuntu-${UBUNTU_VERSION}"
ARG DEBIAN_FRONTEND noninteractive
FROM ${BUILDER_IMAGE}

# install build dependencies
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends apt-utils git curl build-essential inotify-tools imagemagick\
  && apt-get remove -y -q --purge --auto-remove nodejs npm \
  && apt-get clean -y && apt-get autoremove && rm -f /var/lib/apt/lists/*_*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get update -y \
  && apt-get install -f -y -q --no-install-recommends nodejs\
  && apt-get clean -y && apt-get autoremove && rm -f /var/lib/apt/lists/*_*

RUN mix local.hex --force && \
  mix local.rebar --force

RUN npm install -g pnpm@8.15.1

# prepare build dir
ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY docker/dev.entrypoint.sh $APP_HOME/entrypoint.sh
COPY docker/dev.remote.sh $APP_HOME/remote.sh
COPY mix.exs mix.lock .dialyzer_ignore.exs .formatter.exs .credo.exs $APP_HOME/

CMD ["/app/entrypoint.sh"]
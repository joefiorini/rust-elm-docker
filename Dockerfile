FROM node:9.5.0 AS elm-build

RUN mkdir -p /app/src

RUN yarn global add elm

ENV PATH `yarn global bin`:$PATH
# WORKDIR /app

# COPY client/package.json client/yarn.lock ./
# RUN yarn --frozen-lockfile && yarn cache clean

WORKDIR /app/src
COPY client/* /app/src/

CMD yarn start

FROM rustlang/rust:nightly AS api-server.dev

VOLUME ["/usr/local/cargo"]

WORKDIR /src

RUN rustup override set nightly-2018-01-13 && \
    cargo install cargo-watch

CMD /usr/local/cargo/bin/cargo-watch -x run
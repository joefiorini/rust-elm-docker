FROM node:9.5.0 AS elm-build

WORKDIR /src

CMD yarn --force && ./node_modules/.bin/elm-make src/Main.elm

FROM rustlang/rust:nightly AS api-server.dev

VOLUME /src
WORKDIR /src

CMD cargo run
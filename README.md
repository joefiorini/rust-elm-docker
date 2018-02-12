# Rust/Rocket, Elm & Docker

Oh my!

## Usage

In two separate terminal tabs/windows:

### Client

```
docker-compose run elm_run
```

### Server

```
docker-compose run api_server
```

N.B. There's an issue at the moment where the rust container does not properly respond to signals sent to it from the docker host. Restarting the docker daemon is the easiest way to stop the container and ensure port bindings get cleaned up. Will fix this soon.

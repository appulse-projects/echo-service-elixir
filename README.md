# Overview

Simple echo server `Elixir` project for test purposes.

## Run

```bash
$> docker run \
    --name echo-service-elixir \
    --detach \
    --publish 4369:4369 \
    --net=host \
    --network="host" \
    xxlabaza/echo-service-elixir \
      --cookie=secret \
      --name=echo@{IP}
```

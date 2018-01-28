# Overview

Simple echo server `Elixir` project for test purposes.

## Run

```bash
$> docker run \
    --name elixir-test-echo \
    --detach \
    --publish 4369:4369 \
    --net=host \
    --network="host" \
    xxlabaza/elixir-test-echo \
      --cookie=secret \
      --name=echo@{IP}
```

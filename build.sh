#!/bin/sh


set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

( cd ${CURRENT_DIR} ; mix escript.build )

docker build --rm -t xxlabaza/echo-service-elixir ${CURRENT_DIR}/

( cd ${CURRENT_DIR} ; mix clean )

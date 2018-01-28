#!/bin/sh


set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


( cd ${CURRENT_DIR} ; mix clean )
rm -f ${CURRENT_DIR}/echo
docker rmi -f xxlabaza/elixir-test-echo

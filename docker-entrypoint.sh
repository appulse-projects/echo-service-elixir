#!/bin/sh


set -e

epmd -debug -daemon

exec /echo ${@}

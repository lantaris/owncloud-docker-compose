#!/bin/bash

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
. ${SCRIPT_PATH}/.env

echo "--- Cleanup  OwnCloud"
pushd "${SCRIPT_PATH}/work"
  docker-compose down -v
  rm -rf ${SCRIPT_PATH}/work
popd






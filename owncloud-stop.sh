#!/bin/bash

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
. ${SCRIPT_PATH}/.env

echo "--- Stopping OwnCloud"
pushd "${SCRIPT_PATH}/work"
 docker-compose down
popd

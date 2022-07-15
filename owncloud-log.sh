#!/bin/bash


SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
. ${SCRIPT_PATH}/.env

echo "--- Starting Log OwnCloud"
pushd "${SCRIPT_PATH}/work"
 docker-compose logs -f
popd





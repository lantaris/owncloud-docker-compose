#!/bin/bash

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"

docker-compose -f owncloud.yml down -v
rm -rf ${SCRIPT_PATH}/work



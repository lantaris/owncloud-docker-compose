#!/bin/bash

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
BACKUP_DIR="${SCRIPT_PATH}/backup/$(date '+%Y%m%d')"

. ${SCRIPT_PATH}/.env

mkdir -p  ${BACKUP_DIR}

echo "--- Backup database"
docker-compose -f owncloud.yml exec mariadb \
    /usr/bin/mysqldump \
    -u root \
    --password=${DB_ROOT_PASSWORD} \
    --single-transaction \
    owncloud > ${BACKUP_DIR}/owncloud.sql

echo "--- Backup files"
docker run -t --rm -v ${BACKUP_DIR}:/backup  -v owncloud_files:/mnt ubuntu tar czf /backup/files.tgz -C /mnt .


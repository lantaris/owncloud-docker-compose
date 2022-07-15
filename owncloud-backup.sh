#!/bin/bash

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
BACKUP_NAME="$(date '+%Y%m%d')"
BACKUP_DIR="${SCRIPT_PATH}/backup/${BACKUP_NAME}"

. ${SCRIPT_PATH}/.env

rm -rf ${BACKUP_DIR}     || true
rm -rf ${BACKUP_DIR}.tgz || true
mkdir -p  ${BACKUP_DIR}  || true

pushd "${SCRIPT_PATH}/work"
   echo "--- Backup database"
   docker-compose  exec mariadb \
       /usr/bin/mysqldump \
       -u root \
       --password=${DB_ROOT_PASSWORD} \
       --single-transaction \
       owncloud > ${BACKUP_DIR}/owncloud.sql
   
   echo "--- Backup files"
   tar czf ${BACKUP_DIR}/files.tgz -C ${SCRIPT_PATH}/work/data/files .
popd       

pushd "${SCRIPT_PATH}/backup"
  tar czf ${BACKUP_NAME}.tgz ${BACKUP_NAME}
  rm -rf ${BACKUP_DIR}
popd
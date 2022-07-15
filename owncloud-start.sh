#!/bin/bash

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
. ${SCRIPT_PATH}/.env

if [ ! -d "${SCRIPT_PATH}/work" ]; then
  echo "--- Creating work directory"
  mkdir -p ${SCRIPT_PATH}/work
  ln -s ${SCRIPT_PATH}/.env  ${SCRIPT_PATH}/work/.env
  if [ "${ENABLE_SSL}" == "true" ]; then 

      echo "--- Creating directories for certbot"
      mkdir -p ${SCRIPT_PATH}/work/cert/etc
      mkdir -p ${SCRIPT_PATH}/work/cert/var/log
      mkdir -p ${SCRIPT_PATH}/work/cert/var/lib
      
      echo "--- Generation dhparams"   
      openssl dhparam -out ${SCRIPT_PATH}/work/cert/dhparam-2048.pem 2048

      echo "--- Copy nginx configuration"
      mkdir -p ${SCRIPT_PATH}/work/etc/nginx      
      export NGINX_HOST
      j2 -f env -o ${SCRIPT_PATH}/work/etc/nginx/default.conf ${SCRIPT_PATH}/etc/nginx/default.conf.j2     

     echo "--- Generate new certificate for ${NGINX_HOST}"
     docker run -t --rm -v ${SCRIPT_PATH}/work/cert/etc:/etc/letsencrypt \
                     -v ${SCRIPT_PATH}/work/cert/var/lib:/var/lib/letsencrypt \
                     -v ${SCRIPT_PATH}/work/cert/var/log:/var/log/letsencrypt \
                     -p 80:80 \
                        certbot/certbot \
                        certonly --standalone  -n --email ${CERTBOT_EMAIL} --agree-tos --no-eff-email -d ${NGINX_HOST}      
    echo "--- Prepare docker-compose"
    cp -f ${SCRIPT_PATH}/tmpl/owncloud_ssl.yml "${SCRIPT_PATH}/work/docker-compose.yml"
  else
    echo "--- Prepare docker-compose"
    cp -f ${SCRIPT_PATH}/tmpl/owncloud.yml "${SCRIPT_PATH}/work/docker-compose.yml"  
  fi
fi

echo "--- Starting OwnCloud"
pushd "${SCRIPT_PATH}/work"
  docker-compose up -d
popd
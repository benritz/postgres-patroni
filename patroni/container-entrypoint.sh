#!/usr/bin/env bash

set -e

mkdir -p /var/lib/postgresql/data
chown postgres:postgres /var/lib/postgresql/data
chmod 0750 /var/lib/postgresql/data

mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql
chmod 0750 /run/postgresql

if [[ -z "$CLUSTER" ]]; then
  echo "Missing CLUSTER var"
  exit 1
fi

if [[ -z "$BACKUP_NAME" ]]; then
  export BACKUP_NAME=${CLUSTER}
fi

RESTORE_NAME="${RESTORE_NAME:=$BACKUP_NAME}"
RESTORE_PATH="${RESTORE_PATH:=$BACKUP_PATH}"
RESTORE_REGION="${RESTORE_REGION:=$BACKUP_REGION}"
RESTORE_ACCESS_KEY="${RESTORE_ACCESS_KEY:=$BACKUP_ACCESS_KEY}"
RESTORE_SECRET_KEY="${RESTORE_SECRET_KEY:=$BACKUP_SECRET_KEY}"

export RESTORE_NAME
export RESTORE_PATH
export RESTORE_REGION
export RESTORE_ACCESS_KEY
export RESTORE_SECRET_KEY

envsubst </venv/etc/patroni-template.yml >/venv/etc/patroni.yml

write-pgbackrest-conf.sh

export PGPASSFILE=/tmp/pgpass0

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

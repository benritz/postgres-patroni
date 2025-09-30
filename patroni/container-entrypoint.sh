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

export BACKUP_NAME="${BACKUP_NAME:=$CLUSTER}"

export RESTORE_NAME="${RESTORE_NAME:=$BACKUP_NAME}"
export RESTORE_PATH="${RESTORE_PATH:=$BACKUP_PATH}"
export RESTORE_REGION="${RESTORE_REGION:=$BACKUP_REGION}"
export RESTORE_ACCESS_KEY="${RESTORE_ACCESS_KEY:=$BACKUP_ACCESS_KEY}"
export RESTORE_SECRET_KEY="${RESTORE_SECRET_KEY:=$BACKUP_SECRET_KEY}"

envsubst </venv/etc/patroni-template.yml >/venv/etc/patroni.yml

write-pgbackrest-conf.sh

export PGPASSFILE=/tmp/pgpass0

export PGBOUNCER_PWD="${PGBOUNCER_PWD:=password}"
rm -f /usr/local/etc/pgbouncer/userlist.txt
echo "\"pgbouncer\" \"${PGBOUNCER_PWD}\"" >/usr/local/etc/pgbouncer/userlist.txt
pgbouncer -d -q /usr/local/etc/pgbouncer/pgbouncer.ini

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

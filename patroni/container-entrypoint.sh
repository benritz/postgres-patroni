#!/usr/bin/env bash

set -e

mkdir -p /var/lib/postgresql/data
chown postgres:postgres /var/lib/postgresql/data
chmod 0750 /var/lib/postgresql/data

envsubst </venv/etc/patroni-template.yml >/venv/etc/patroni.yml

write-pgbackrest-conf.sh

# pgbackrest --stanza="$BACKUP_NAME" --log-level-console=info stanza-create
if [ -z "$(ls -A '/var/lib/postgresql/data')" ]; then
  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail restore
fi

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

#!/usr/bin/env bash

set -e

if [[ -f "/var/run/postgresql/post-init-db" ]]; then
  echo "Running post init db scripts"
  envsubst </usr/local/etc/pgbouncer/pgbouncer-init-template.sql >/var/lib/postgresql/pgbouncer-init.sql
  psql -U postgres -f /var/lib/postgresql/pgbouncer-init.sql
  rm /var/lib/postgresql/pgbouncer-init.sql
fi

if [[ -z "$BACKUP_NAME" ]]; then
  echo "Error: Missing BACKUP_NAME."
  exit 1
fi

STANZA_STATE=$(pgbackrest --stanza="$BACKUP_NAME" --output=json info | jq -r .[0].status.message)

echo "Stanza $BACKUP_NAME: $STANZA_STATE"

if [ "$STANZA_STATE" != "ok" ]; then
  # stanza missing - create stanza
  echo "Create stanza $BACKUP_NAME"

  until pg_isready -h localhost -p 5432 -U postgres; do
    echo "Waiting for postgres"
    sleep 5
  done

  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail stanza-create
  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail --type=full backup
fi

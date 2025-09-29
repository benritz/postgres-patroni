#!/usr/bin/env bash

set -e

if [[ -z "$BACKUP_NAME" ]]; then
  echo "Error: Missing BACKUP_NAME."
  exit 1
fi

STANZA_STATE=$(pgbackrest --stanza="$BACKUP_NAME" --output=json info | jq -r .[].status.message)

echo "Stanza $BACKUP_NAME: $STANZA_STATE"

if [ $STANZA_STATE != "ok" ]; then
  # stanza missing - create stanza
  echo "Create stanza $BACKUP_NAME"

  until pg_isready -h localhost -p 5432 -U postgres; do
    echo "Waiting for postgres"
    sleep 5
  done

  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail stanza-create
  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail --type=full backup
fi

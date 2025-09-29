#!/usr/bin/env bash

set -e

if [[ -z "$BACKUP_NAME" ]]; then
  echo "Error: Missing BACKUP_NAME."
  exit 1
fi

STANZA_STATE=$(pgbackrest --stanza="$BACKUP_NAME" --output=json info | jq -r .[].status.message)

echo "Stanza $BACKUP_NAME: $STANZA_STATE"

if [ $STANZA_STATE == "ok" ]; then
  # stanza ok - restore db
  echo "Restore from stanza $BACKUP_NAME"
  pgbackrest --stanza="$BACKUP_NAME" --log-level-console=detail restore
else
  # stanza missing - init db - post bookstrap script will create stanza after postgres is available
  echo "No stanza - init db"
  initdb -D /var/lib/postgresql/data --encoding UTF8
fi

#!/usr/bin/env bash

set -e

if [[ -z "$RESTORE_NAME" ]]; then
  echo "Error: Missing RESTORE_NAME."
  exit 1
fi

STANZA_STATE=$(pgbackrest --stanza="$RESTORE_NAME" --output=json info | jq -r .[0].status.message)

echo "Stanza $RESTORE_NAME: $STANZA_STATE"

if [ "$STANZA_STATE" == "ok" ]; then
  # stanza ok - restore db
  echo "Restore from stanza $RESTORE_NAME"
  pgbackrest --stanza="$RESTORE_NAME" --log-level-console=detail restore
else
  # stanza missing - init db - post bookstrap script will create stanza after postgres is available
  echo "No stanza - init db"
  initdb -D /var/lib/postgresql/data --encoding UTF8 --data-checksums
  touch /var/run/postgresql/post-init-db
fi

#!/usr/bin/env bash

set -e

EVT=$1
ROLE=$2

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXX $EVT $ROLE"

if [ "$EVT" == "on_role_change" ] && [ "$ROLE" == "primary" ]; then
  # the backup should be initialised in patroni-post-bootstrap.sh but the
  # backup stanza could be deleted after bootstrapping the database
  patroni-init-backup.sh
fi

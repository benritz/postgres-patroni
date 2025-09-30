#!/usr/bin/env bash

set -e

if [[ -f "/var/run/postgresql/post-init-db" ]]; then
  echo "Running post init db scripts"
  envsubst </usr/local/etc/pgbouncer/pgbouncer-init-template.sql >/var/lib/postgresql/pgbouncer-init.sql
  psql -U postgres -f /var/lib/postgresql/pgbouncer-init.sql
  rm /var/lib/postgresql/pgbouncer-init.sql
fi

patroni-init-backup.sh

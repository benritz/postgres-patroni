#!/usr/bin/env bash

if [ ! -d "/var/lib/postgresql/data" ]; then
  mkdir -p /var/lib/postgresql/data
  chown postgres:postgres /var/lib/postgresql/data
  su-exec postgres initdb -D /var/lib/postgresql/data
  set -e

  su-exec postgres psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE ${NOME_DB};
    GRANT ALL PRIVILEGES ON DATABASE ${NOME_DB} TO ${NOME_DB_USER};
EOSQL
fi

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

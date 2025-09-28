#!/usr/bin/env bash

set -e

mkdir -p /var/lib/postgresql/data
chown postgres:postgres /var/lib/postgresql/data
chmod 0750 /var/lib/postgresql/data

mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql
chmod 0750 /run/postgresql

envsubst </venv/etc/patroni-template.yml >/venv/etc/patroni.yml

write-pgbackrest-conf.sh

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

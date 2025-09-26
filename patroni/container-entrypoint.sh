#!/usr/bin/env bash

set -e

chmod 0750 /var/lib/postgresql/data

envsubst </venv/etc/patroni-template.yml >/venv/etc/patroni.yml

exec su-exec postgres /venv/bin/patroni /venv/etc/patroni.yml

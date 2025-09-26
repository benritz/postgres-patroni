#!/usr/bin/env bash

set -e

if [[ -z "$BACKUP_NAME" ]]; then
  echo "Error: Missing BACKUP_NAME."
  exit 1
fi

if [[ -z "$BACKUP_PATH" ]]; then
  echo "Error: Missing BACKUP_PATH."
  exit 1
fi

if [[ -z "$BACKUP_REGION" ]]; then
  echo "Error: Missing BACKUP_REGION."
  exit 1
fi

if [[ -z "$BACKUP_RETENTION" ]]; then
  export BACKUP_RETENTION=4
fi

BACKUP_S3_BUCKET=$(echo "$BACKUP_PATH" | sed -E 's|^s3://([^/]+)/.*$|\1|')
BACKUP_S3_PATH=$(echo "$BACKUP_PATH" | sed -E 's|^s3://[^/]+/(.*)$|\1|')

if [[ -z "$BACKUP_S3_BUCKET" ]]; then
  echo "Error: Invalid BACKUP_PATH."
  exit 1
fi

if [[ "$BACKUP_S3_PATH" == "$BACKUP_PATH" ]]; then
  BACKUP_S3_PATH=""
fi

export BACKUP_S3_BUCKET
export BACKUP_S3_PATH

if [[ -z "$BACKUP_ACCESS_KEY" || -z "$BACKUP_SECRET_KEY" ]]; then
  sed '/# S3_AUTH_BEGIN/,/# S3_AUTH_END/d' /opt/ibase/pgbackrest-template.conf | envsubst >/etc/pgbackrest/pgbackrest.conf
else
  envsubst </etc/pgbackrest/pgbackrest-template.conf >/etc/pgbackrest/pgbackrest.conf
fi

chown postgres:postgres /etc/pgbackrest/pgbackrest.conf

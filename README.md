# postgres-patroni

Postgres run by Patroni for HA, etcs for DSC, HAProxy for load balancing, pgBackRest for backup/restore, PgBouncer for connection pooling

## Environment variables

The following variables must be set before running docker compose up.

- CLUSTER - the name of the cluster

ETCD_NAME - defaults to hostname
ETCD_INITIAL_CLUSTER - no default, e.g. "etcd_01=http://etcd_01:2380,etcd_02=http://etcd_02:2380"

- BACKUP_REGION
- BACKUP_PATH
- BACKUP_ACCESS_KEY
- BACKUP_SECRET_KEY

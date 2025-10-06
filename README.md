# postgres-patroni

PostgreSQL high availability using Patroni, etcd for the distributed configuration store, HAProxy for load balancing, pgBackRest for backup/restore and PgBouncer for connection pooling.

## Environment variables

The following must be set before running docker compose up.

- CLUSTER - the name of the cluster.
- CA_ROOT_CERT and CA_ROOT_KEY - the root certificate and key used to sign the certificates used by the services, these can be set using docker secrets and the CA_ROOT_KEY_FILE/CA_ROOT_KEY_FILE vars.

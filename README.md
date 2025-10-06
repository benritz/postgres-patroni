# postgres-patroni

PostgreSQL high availability using Patroni, etcd for the distributed configuration store, HAProxy for load balancing, pgBackRest for backup/restore and PgBouncer for connection pooling.

## Environment variables

Use `.env.example` as a starting point:

```bash
cp .env.example .env
```

### Required

- CLUSTER: Cluster name used by Patroni and pgBackRest.
- CA_ROOT_CERT_FILE, CA_ROOT_KEY_FILE: Paths to the Root CA certificate/key inside containers. These are provided via Docker secrets; create files under `./secrets`:
  - `./secrets/ca_root_cert`
  - `./secrets/ca_root_key`
  You can generate them with `gen-ca` sub-project (see `gen-ca/README.md`).

### Certificates

- CERT_C, CERT_ST, CERT_L, CERT_O, CERT_OU: Subject fields for service certificates.
- CERT_CN: Common Name; defaults to the container hostname if unset.
- CERT_EXPIRY: Certificate validity in cfssl duration format. Default `8760h` (1 year).
- CERT_KEY_ALGO: `ecdsa` or `rsa`. Default `ecdsa`.
- CERT_KEY_SIZE: If `ecdsa` -> `256`/`384`/`521`; if `rsa` -> `2048`/`3072`/`4096`.

### etcd

- ETCD_HOSTS: Comma-separated etcd client endpoints (default matches `compose.yaml`).
- ETCD_INITIAL_CLUSTER_TOKEN_FILE: Optional token provided via secret `./secrets/etcd_initial_cluster_token`.

### HAProxy

- TARGETS: Backend targets, typically the PgBouncer ports of Postgres nodes (e.g., `pg_01:6432,pg_02:6432`).

### Postgres + PgBouncer Authentication

- POSTGRES_SU_PWD_FILE: Secret for superuser password (`./secrets/postgres_su_password`).
- POSTGRES_REPL_PWD_FILE: Secret for replication user (`./secrets/postgres_repl_password`).
- POSTGRES_REWIND_PWD_FILE: Secret for rewind user (`./secrets/postgres_rewind_password`).
- PGBOUNCER_PWD_FILE: Secret for PgBouncer auth (`./secrets/pgbouncer_password`).

### pgBackRest Backup

- BACKUP_NAME: Defaults to `CLUSTER` if unset.
- BACKUP_REGION_FILE, BACKUP_PATH_FILE: S3 region and bucket/path (secrets: `./secrets/backup_region`, `./secrets/backup_path`).
- BACKUP_ACCESS_KEY_FILE, BACKUP_SECRET_KEY_FILE: Credentials secrets (optional when using an AWS EC2 instance profile).

### pgBackRest Restore

- RESTORE_NAME: Defaults to `CLUSTER` if unset.
- RESTORE_REGION_FILE, RESTORE_PATH_FILE: S3 region and path for restore (`./secrets/restore_region`, `./secrets/restore_path`).
- RESTORE_ACCESS_KEY_FILE, RESTORE_SECRET_KEY_FILE: Credentials secrets (optional when using an AWS EC2 instance profile).

## Running

- Set the required environment variables in `.env` or `compose.yaml`
- Ensure required secrets exist under `./secrets` as referenced above.
- Build and start the stack:

```bash
docker compose up --build
```

## Client Connections

- Postgres read/write TLS connection to primary server: Host port `5432` → HAProxy `5432` → PgBouncer `6432` → Postgres `5432` on the primary server.
- Postgres read-only TLS connection to any server (primary or standby): Host port `5433` → HAProxy `5433` → PgBouncer `6432` → Postgres `5432` on any server.
- HAProxy stats web UI: Host port `8001` → HAProxy stats web UI `7000`

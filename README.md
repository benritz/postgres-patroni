# postgres-patroni

PostgreSQL high availability implemented by Patroni, etcd for the distributed configuration store, HAProxy for load balancing, pgBackRest for backup/restore and PgBouncer for connection pooling.

## Environment variables

Use `.env.example` as a starting point:

```bash
cp .env.example .env
```

Prefix-based secret values are supported for all sensitive vars:
- ssm:/path: Fetch from AWS SSM Parameter Store (with decryption)
- file:/path: Read from a file (e.g., Docker secret)
- value:raw: Literal value
- raw without prefix: Treated as a literal value


### Required

- CLUSTER: Cluster name used by Patroni and pgBackRest.
- CA_ROOT_CERT, CA_ROOT_KEY: Root CA certificate/key contents provided via prefixes above. Typical via Docker secrets:
  - `CA_ROOT_CERT=file:/run/secrets/ca_root_cert`
  - `CA_ROOT_KEY=file:/run/secrets/ca_root_key`
  You can generate them with `gen-ca` sub-project (see `gen-ca/README.md`).

### Certificates

- CERT_C, CERT_ST, CERT_L, CERT_O, CERT_OU: Subject fields for service certificates.
- CERT_CN: Common Name; defaults to the container hostname if unset.
- CERT_EXPIRY: Certificate validity in cfssl duration format. Default `8760h` (1 year).
- CERT_KEY_ALGO: `ecdsa` or `rsa`. Default `ecdsa`.
- CERT_KEY_SIZE: If `ecdsa` -> `256`/`384`/`521`; if `rsa` -> `2048`/`3072`/`4096`.

### etcd

- ETCD_HOSTS: Comma-separated etcd client endpoints (default matches `compose.yaml`).
- ETCD_INITIAL_CLUSTER_TOKEN: Token via prefix value, e.g. `value:token`, `file:/run/secrets/etcd_initial_cluster_token`, or `ssm:/prod/etcd/cluster-token`.

### HAProxy

- TARGETS: Backend targets, typically the PgBouncer ports of Postgres nodes (e.g., `pg_01:6432,pg_02:6432`).

### Postgres + PgBouncer Authentication

- POSTGRES_SU_USER, POSTGRES_SU_PWD
- POSTGRES_REPL_USER, POSTGRES_REPL_PWD
- POSTGRES_REWIND_USER, POSTGRES_REWIND_PWD
Use prefixes for passwords, e.g. `file:/run/secrets/postgres_su_password` or `ssm:/prod/db/postgres/su_password`.

### pgBackRest Backup

- BACKUP_NAME: Defaults to `CLUSTER` if unset.
- BACKUP_REGION, BACKUP_PATH: S3 region and bucket/path via prefixes.
- BACKUP_ACCESS_KEY, BACKUP_SECRET_KEY: Credentials via prefixes (optional with instance profile).

### pgBackRest Restore

- RESTORE_NAME: Defaults to `CLUSTER` if unset.
- RESTORE_REGION, RESTORE_PATH: S3 region and path for restore via prefixes.
- RESTORE_ACCESS_KEY, RESTORE_SECRET_KEY: Credentials via prefixes (optional with instance profile).

## Running

- Set the required environment variables in `.env` or `compose.yaml`
- Ensure required secrets exist under `./secrets` as referenced above.
- Build and start the stack:

```bash
docker compose up --build
```

## Client Connections

- Postgres read/write connection to primary server: Docker Host `tcp/tls:5432` → HAProxy `tcp/tls:5432` → PgBouncer `tcp/ssl:6432` → Postgres `unix socket` on the primary server.
- Postgres read-only TLS connection to any server (primary or standby): Docker Host `tcp/tls:5433` → HAProxy `tcp/tls:5433` → PgBouncer `tcp/ssl:6432` → Postgres `unix socket` on any server.

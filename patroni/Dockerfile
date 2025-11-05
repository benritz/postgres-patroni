FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv \
    libpq-dev \
    build-base \
    linux-headers \
    python3-dev

RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install psycopg2 && \
    /venv/bin/pip install 'patroni[etcd]'


FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    postgresql17 \
    postgresql17-contrib \
    pgbackrest \
    pgbouncer \
    su-exec \
    python3 \
    musl-locales \
    envsubst \
    jq \
    shadow \
    dcron \
    tini \
    aws-cli && \
  apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing
  
WORKDIR /usr/local/bin/
COPY . .

# Bring in the prebuilt venv with psycopg2 and patroni
COPY --from=builder /venv /venv

# Layout configs and runtime directories
RUN mkdir /venv/etc && \
  mv patroni.yml /venv/etc/patroni-template.yml && \
  mkdir -p /usr/local/etc/pgbouncer && \
  mv pgbouncer.ini /usr/local/etc/pgbouncer && \
  mv pgbouncer-init-template.sql /usr/local/etc/pgbouncer && \
  mkdir -p /var/run/pgbouncer && \
  chown -R pgbouncer /var/run/pgbouncer && \
  chown -R pgbouncer /usr/local/etc/pgbouncer && \
  chsh -s /bin/bash pgbouncer && \
  usermod -m -d /home/pgbouncer pgbouncer || true && mkdir -p /home/pgbouncer && chown -R pgbouncer:postgres /home/pgbouncer && \
  mv pgbackrest-template.conf /etc/pgbackrest/pgbackrest-template.conf && \
  mkdir -p /tmp/pgbackrest && \
  chown -R postgres /tmp/pgbackrest

ENTRYPOINT ["tini","-g","--","container-entrypoint"]

EXPOSE 5432 6432 8008 8009

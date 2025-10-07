FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    postgresql \
    pgbackrest \
    pgbouncer \
    libpq-dev \
    su-exec \
    build-base \
    linux-headers \
    python3-dev \
    py3-pip \
    py3-virtualenv \
    musl-locales \
    envsubst \
    jq \
    shadow \
    dcron && \
  apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing
  
WORKDIR /usr/local/bin/
COPY . . 

RUN python3 -m venv /venv && \
  mkdir /venv/etc && \
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
  chown -R postgres /tmp/pgbackrest && \
  cd /venv && \
  ./bin/pip install psycopg2 && \
  ./bin/pip install patroni[etcd]

ENTRYPOINT ["container-entrypoint"]

EXPOSE 5432 6432 8008 8009

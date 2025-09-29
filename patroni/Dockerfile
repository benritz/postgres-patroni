FROM alpine:latest

WORKDIR /usr/local/bin/
COPY . . 

RUN apk add --no-cache bash \
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
  jq && \
  python3 -m venv /venv && \
  mkdir /venv/etc && \
  mv patroni.yml /venv/etc/patroni-template.yml && \
  mkdir -p /usr/local/etc && \
  mv pgbouncer.ini /usr/local/etc/pgbouncer.ini && \
  echo "\"pgbouncer_auth_user\" \"password\"" > /usr/local/etc/userlist.txt && \
  mkdir -p /var/run/pgbouncer && \
  chown -R pgbouncer /var/run/pgbouncer && \
  chmod +x *.sh && \
  mv pgbackrest-template.conf /etc/pgbackrest/pgbackrest-template.conf && \
  cd /venv && \
  ./bin/pip install psycopg2 && \
  ./bin/pip install patroni[etcd]

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 5432 8008 6432

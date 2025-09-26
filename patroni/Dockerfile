FROM postgres:17-alpine

RUN apk add --no-cache su-exec build-base linux-headers python3-dev py3-pip py3-virtualenv musl-locales envsubst \
    && python3 -m venv /venv && mkdir /venv/etc
WORKDIR /venv
RUN ./bin/pip install psycopg2 && ./bin/pip install patroni[etcd]
COPY patroni.yml /venv/etc/patroni-template.yml

WORKDIR /var/lib/postgresql

COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh
RUN chmod +x /usr/local/bin/container-entrypoint.sh

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 5432 8008

FROM alpine:latest

ENV ETCD_01=
ENV ETCD_02=
ENV BACKUP_NAME=

RUN apk add --no-cache bash postgresql pgbackrest libpq-dev su-exec build-base linux-headers python3-dev py3-pip py3-virtualenv musl-locales envsubst \
    && python3 -m venv /venv && mkdir /venv/etc
WORKDIR /venv
RUN ./bin/pip install psycopg2 && ./bin/pip install patroni[etcd]
COPY patroni.yml /venv/etc/patroni-template.yml

WORKDIR /var/lib/postgresql

COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh
RUN chmod +x /usr/local/bin/container-entrypoint.sh

COPY write-pgbackrest-conf.sh /usr/local/bin/write-pgbackrest-conf.sh
RUN chmod +x /usr/local/bin/write-pgbackrest-conf.sh

COPY pgbackrest-template.conf /etc/pgbackrest/pgbackrest-template.conf

RUN ln -s /usr/libexec/postgresql/* /usr/local/bin/

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 5432 8008

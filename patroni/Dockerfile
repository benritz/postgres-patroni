FROM postgres:17-alpine as postgres-patroni

RUN apk add --no-cache su-exec build-base linux-headers python3-dev py3-pip py3-virtualenv \
    && python3 -m venv /venv && mkdir /venv/etc

# Create a virtual environment
# RUN python3 -m venv /venv && mkdir /venv/etc

# Install Patroni
WORKDIR /venv
# RUN /venv/bin/pip install patroni[etcd]
RUN ./bin/pip install psycopg2 && ./bin/pip install patroni[etcd]

COPY patroni.yml /venv/etc/patroni.yml

WORKDIR /var/lib/postgresql

# blocco avvio postgresql
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 5432 8008

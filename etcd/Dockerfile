FROM alpine:latest

WORKDIR /usr/local/bin/
COPY . .

RUN apk add bash etcd etcd-ctl && \
  chmod +x *.sh

VOLUME /var/etcd-data

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 2379
EXPOSE 2380 

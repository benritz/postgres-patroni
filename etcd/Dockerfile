FROM alpine:3.23

WORKDIR /usr/local/bin/
COPY . .

RUN apk --no-cache add bash su-exec etcd etcd-ctl aws-cli jq tini && \
  apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing

VOLUME /var/etcd-data

ENTRYPOINT ["tini","-g","--","container-entrypoint"]

EXPOSE 2379
EXPOSE 2380 



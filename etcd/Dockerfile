FROM alpine:3.22

WORKDIR /usr/local/bin/
COPY . .

RUN apk --no-cache add bash su-exec etcd etcd-ctl ca-certificates aws-cli jq && \
  apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing

VOLUME /var/etcd-data

ENTRYPOINT ["container-entrypoint"]

EXPOSE 2379
EXPOSE 2380 



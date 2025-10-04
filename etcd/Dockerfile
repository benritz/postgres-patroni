FROM alpine:3.22

WORKDIR /usr/local/bin/
COPY . .

RUN apk --no-cache add bash etcd etcd-ctl 

VOLUME /var/etcd-data

ENTRYPOINT ["container-entrypoint"]

EXPOSE 2379
EXPOSE 2380 

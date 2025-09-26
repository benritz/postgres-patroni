FROM alpine:latest

ENV ETCD_NAME=
ENV ETCD_DATA_DIR=/var/etcd-data
ENV ETCD_INITIAL_ADVERTISE_PEER_URLS=
ENV ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
ENV ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
ENV ETCD_ADVERTISE_CLIENT_URLS=
ENV ETCD_INITIAL_CLUSTER=
ENV ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster
ENV ETCD_INITIAL_CLUSTER_STATE=new

RUN apk add bash etcd etcd-ctl

WORKDIR /usr/bin/
COPY container-entrypoint.sh .
RUN chmod +x container-entrypoint.sh

VOLUME /var/etcd-data

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 2379
EXPOSE 2380 

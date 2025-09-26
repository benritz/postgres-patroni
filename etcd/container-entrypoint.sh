#!/usr/bin/env bash

if [ -z "$ETCD_NAME" ]; then
  export ETCD_NAME=${HOSTNAME}
fi

DOMAIN=$(hostname)

export ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${DOMAIN}:2380
export ETCD_ADVERTISE_CLIENT_URLS=http://${DOMAIN}:2379

etcd

#!/usr/bin/env bash

set -e

if [ -z "$ETCD_NAME" ]; then
  export ETCD_NAME=${HOSTNAME}
fi

export ETCD_DATA_DIR=/var/etcd-data
export ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${HOSTNAME}:2380
export ETCD_ADVERTISE_CLIENT_URLS=http://${HOSTNAME}:2379
export ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
export ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
export ETCD_INITIAL_CLUSTER_STATE=new

etcd

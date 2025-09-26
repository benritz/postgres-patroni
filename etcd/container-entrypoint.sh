#!/usr/bin/env bash

set -e

if [ -z "$ETCD_NAME" ]; then
  export ETCD_NAME=${HOSTNAME}
fi

export ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${HOSTNAME}:2380
export ETCD_ADVERTISE_CLIENT_URLS=http://${HOSTNAME}:2379

etcd

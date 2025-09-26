# Etcd

## Envirionment variables

```bash
ETCD_NAME - defaults to hostname
ETCD_DATA_DIR - defaults to /var/etcd-data
ETCD_INITIAL_ADVERTISE_PEER_URLS - defaults to http://${HOSTNAME}:2380
ETCD_LISTEN_PEER_URLS - defaults to http://0.0.0.0:2380
ETCD_LISTEN_CLIENT_URLS - defaults http://0.0.0.0:2379
ETCD_ADVERTISE_CLIENT_URLS - defaults to http://${HOSTNAME}:2379
ETCD_INITIAL_CLUSTER - no default, e.g. "etcd_01=http://etcd_01:2380,etcd_02=http://etcd_02:2380"
ETCD_INITIAL_CLUSTER_TOKEN - defaults to etcd-cluster
ETCD_INITIAL_CLUSTER_STATE - defaults to new

## Run container

```bash
docker run --rm --name etcd_01 --network etcd_cluster --hostname etcd_01 --ip 192.168.0.5 -e ETCD_INITIAL_CLUSTER="etcd_01=http://etcd_01:2380,etcd_02=http://etcd_02:2380" -d etcd

docker run --rm --name etcd_02 --network etcd_cluster --hostname etcd_02 --ip 192.168.0.6 -e ETCD_INITIAL_CLUSTER="etcd_01=http://etcd_01:2380,etcd_02=http://etcd_02:2380" -d etcd

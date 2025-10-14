
variable "REGISTRY" {
  default = "localhost"
}

group "default" {
  targets = ["etcd", "patroni", "haproxy", "gen-ca"]
}

target "etcd" {
  context = "./etcd"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/postgres-patroni/etcd:latest"]
}

target "patroni" {
  context = "./patroni"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/postgres-patroni/patroni:latest"]
}

target "haproxy" {
  context = "./haproxy"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/postgres-patroni/haproxy:latest"]
}

target "gen-ca" {
  context = "./gen-ca"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/postgres-patroni/gen-ca:latest"]
}

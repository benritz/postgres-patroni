# REGISTRY must end in a forward slash
variable "REGISTRY" {
  default = "postgres-patroni"
}

group "default" {
  targets = ["etcd", "patroni", "haproxy", "gen-ca"]
}

target "etcd" {
  context = "./etcd"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/etcd:latest"]
}

target "patroni" {
  context = "./patroni"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/patroni:latest"]
}

target "haproxy" {
  context = "./haproxy"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/haproxy:latest"]
}

target "gen-ca" {
  context = "./gen-ca"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}/gen-ca:latest"]
}

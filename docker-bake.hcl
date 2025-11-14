variable "REGISTRY" {
  default = "postgres-patroni/"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["etcd", "patroni", "haproxy", "gen-ca"]
}

target "etcd" {
  context = "./etcd"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}etcd:${TAG}"]
}

target "patroni" {
  context = "./patroni"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}patroni:${TAG}"]
}

target "haproxy" {
  context = "./haproxy"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}haproxy:${TAG}"]
}

target "gen-ca" {
  context = "./gen-ca"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${REGISTRY}gen-ca:${TAG}"]
}

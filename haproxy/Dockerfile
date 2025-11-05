FROM alpine:3.22

WORKDIR /usr/local/bin/
COPY . .
RUN apk --no-cache add bash su-exec haproxy socat util-linux-misc aws-cli tini && \
  apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  mkdir -p /usr/local/etc/haproxy && \
  mv haproxy-template.cfg /usr/local/etc/haproxy/haproxy-template.cfg

ENTRYPOINT ["tini","-g","--","container-entrypoint"]

EXPOSE 5432 5433


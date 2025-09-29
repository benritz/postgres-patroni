FROM alpine:latest

WORKDIR /usr/local/bin/
COPY . .
RUN apk add bash haproxy && \
  chmod +x *.sh && \
  mkdir -p /usr/local/etc/haproxy && \
  mv haproxy-template.cfg /usr/local/etc/haproxy/haproxy-template.cfg

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 5000 5001

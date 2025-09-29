FROM haproxytech/haproxy-alpine:latest

WORKDIR /usr/local/bin/
COPY . .
RUN apk add bash && \
  chmod +x *.sh && \
  rm -f /usr/local/etc/haproxy/haproxy.cfg && \
  mv haproxy-template.cfg /usr/local/etc/haproxy/haproxy-template.cfg

ENTRYPOINT ["container-entrypoint.sh"]

EXPOSE 5000 5001

FROM alpine:latest

WORKDIR /usr/local/bin
COPY . .
RUN apk add bash pgbouncer && \
  chmod +x container-entrypoint.sh

ENTRYPOINT ["container-entrypoint.sh"]

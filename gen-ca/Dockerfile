FROM alpine:3.22

RUN apk add --no-cache bash && \
    apk add --no-cache cfssl --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing

ENV CERT_PATH=/usr/local/etc/ssl

RUN cat > /usr/local/bin/gen-ca <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

CERT_PATH="${CERT_PATH:-/usr/local/etc/ssl}"
CERT_KEY_ALGO="${CERT_KEY_ALGO:-ecdsa}"
CERT_KEY_SIZE="${CERT_KEY_SIZE:-256}"
CERT_EXPIRE="${CERT_EXPIRE:-87600h}"  # 10 years
CERT_CN="${CERT_CN:-Test CA}"
CERT_C="${CERT_C:-US}"
CERT_ST="${CERT_ST:-}"
CERT_L="${CERT_L:-}"
CERT_O="${CERT_O:-Test}"
CERT_OU="${CERT_OU:-}"

mkdir -p "$CERT_PATH"

CSR_JSON="$(mktemp)"
cat > "$CSR_JSON" <<JSON
{
  "CN": "${CERT_CN}",
  "key": {
    "algo": "${CERT_KEY_ALGO}",
    "size": ${CERT_KEY_SIZE}
  },
  "names": [
    {
      "C": "${CERT_C}",
      "ST": "${CERT_ST}",
      "L": "${CERT_L}",
      "O": "${CERT_O}",
      "OU": "${CERT_OU}"
    }
  ],
  "ca": {
    "expiry": "${CERT_EXPIRE}"
  }
}
JSON

umask 077
cd "$CERT_PATH"
rm -f ca-key.pem ca.pem ca.csr || true
cfssl gencert -initca "$CSR_JSON" | cfssljson -bare ca
rm -f "$CSR_JSON" ca.csr
chmod 600 "$CERT_PATH/ca-key.pem" || true

echo "Generated: $CERT_PATH/ca.pem and $CERT_PATH/ca-key.pem"
EOF

RUN chmod +x /usr/local/bin/gen-ca

VOLUME ["/usr/local/etc/ssl"]

ENTRYPOINT ["/usr/local/bin/gen-ca"]

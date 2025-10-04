# gen-ca

Generate a private Root CA certificate and key for local development or internal production use. The generated files can be used as ca_root_cert and ca_root_key secrets for the main project.

- Output: `./certs/ca.pem` (public certificate) and `./certs/ca-key.pem` (private key)

## Quick start
1. Copy and edit environment variables:
   ```bash
   cp .env.example .env
   ```
2. Edit .env to set CN, key algorithm/size, subject fields, etc.
3. Build and run the generator:
   ```bash
   docker compose up --build
   ```
3. Collect the generated files:
   - `certs/ca.pem` – Root CA certificate (distributable)
   - `certs/ca-key.pem` – Root CA private key (sensitive; protect!)

## Configuration
Configure via `.env` or Compose environment. Sensible defaults are provided.

- `CERT_CN` (string): Common Name for the CA.
- `CERT_KEY_ALGO` (`ecdsa`|`rsa`): Key algorithm. Default: `ecdsa`.
- `CERT_KEY_SIZE` (number): Key size.
  - ECDSA: `256`, `384`, or `521` (Default: `384`)
  - RSA: `2048`, `3072`, `4096`
- `CERT_EXPIRE` (duration): CA validity in cfssl duration format. Default: `87600h` (~10 years).
- `CERT_C`, `CERT_ST`, `CERT_L`, `CERT_O`, `CERT_OU` (strings): Subject fields. Defaults: `C=US`, `O=Test`.
- `CERT_PATH` (path): Where certs are written inside the container. Default: `/usr/local/etc/ssl` (mapped to `./certs`).

An example file is provided at `.env.example` with common values and comments.

## Inspecting the certificate
Use OpenSSL (or cfssl) on the host after generation:

```bash
# OpenSSL (human-readable)
openssl x509 -in ./certs/ca.pem -text -noout

# cfssl (JSON)
cfssl certinfo -cert ./certs/ca.pem | jq
```

## Integrating with the main project
- Copy certs/ca.pem to ../secrets/ca_root_cert 
- Copy certs/ca-key.pem to ../secrets/ca_root_key

```bash
cp -f certs/ca.pem ../secrets/ca_root_cert
cp -f certs/ca-key.pem ../secrets/ca_root_key
```

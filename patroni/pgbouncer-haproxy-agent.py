#!/usr/bin/env python3
import os, socket

# PgBouncer-only HAProxy agent line protocol.
# Sends a single line then closes. HAProxy parses first tokens.
# Output: 'ready' when PgBouncer TCP port is reachable, otherwise 'down'.
# (Could also append weight directives: e.g., 'ready weight 100'.)

PGBOUNCER_HOST = os.getenv("PGBOUNCER_HOST", "127.0.0.1")
PGBOUNCER_PORT = int(os.getenv("PGBOUNCER_PORT", "6432"))
AGENT_PORT = int(os.getenv("AGENT_PORT", "8009"))
TIMEOUT = float(os.getenv("AGENT_TIMEOUT", "1.0"))
BACKLOG = 32


def pgbouncer_ok():
    try:
        with socket.create_connection((PGBOUNCER_HOST, PGBOUNCER_PORT), TIMEOUT):
            return True
    except OSError:
        return False


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as srv:
        srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        srv.bind(("0.0.0.0", AGENT_PORT))
        srv.listen(BACKLOG)
        while True:
            conn, _ = srv.accept()
            with conn:
                state = "up" if pgbouncer_ok() else "down"
                try:
                    conn.sendall(state.encode() + b"\n")
                except BrokenPipeError:
                    pass

if __name__ == "__main__":
    main()

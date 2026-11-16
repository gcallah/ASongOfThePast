#!/usr/bin/env bash
# Paradev run: serve the site with a static dev server on a per-workspace port.
# Override with PORT=1234. Otherwise the start port is derived from the
# workspace name (stable across restarts) and bumped until a free one is found.
set -euo pipefail

WS="${SUPERSET_WORKSPACE_PATH:-$PWD}"
cd "$WS"

if [[ -z "${PORT:-}" ]]; then
  name="${SUPERSET_WORKSPACE_NAME:-$(basename "$WS")}"
  start=$(( 8000 + $(printf '%s' "$name" | cksum | cut -d' ' -f1) % 900 ))
  PORT=$(python3 - "$start" <<'PY'
import socket, sys
p = int(sys.argv[1])
for port in range(p, p + 200):
    s = socket.socket()
    try:
        s.bind(("127.0.0.1", port))
        print(port); break
    except OSError:
        continue
    finally:
        s.close()
else:
    sys.exit("run: no free port found")
PY
)
fi

echo $$ > "$(git rev-parse --git-path paradev-run.pid)"
echo "run: serving $WS at http://127.0.0.1:$PORT"
exec python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$WS"

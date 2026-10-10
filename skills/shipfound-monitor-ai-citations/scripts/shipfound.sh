#!/bin/sh
# Call one Shipfound tool and print the server's JSON reply.
#
#   sh shipfound.sh workspace
#   sh shipfound.sh visibility_run
#   sh shipfound.sh visibility
#
# Needs SHIPFOUND_API_KEY (a wl_ key from https://www.shipfound.co/app, Settings,
# MCP connection). Talks only to the Shipfound API; sends nothing else anywhere
# and keeps nothing on disk.

set -eu

tool="${1:-}"
case "$tool" in
  workspace | visibility_run | visibility) ;;
  *)
    echo "usage: sh shipfound.sh workspace|visibility_run|visibility" >&2
    exit 2
    ;;
esac

if [ -z "${SHIPFOUND_API_KEY:-}" ]; then
  echo "SHIPFOUND_API_KEY is not set. Make a key at https://www.shipfound.co/app (Settings, MCP connection) and export it." >&2
  exit 3
fi

api="${SHIPFOUND_API_URL:-https://api.shipfound.co}"

curl -sS --max-time 60 "$api/mcp" \
  -H "Authorization: Bearer $SHIPFOUND_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$tool\",\"arguments\":{}}}"
echo

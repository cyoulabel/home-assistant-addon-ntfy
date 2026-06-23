#!/bin/sh
set -eu
mkdir -p /share/ntfy/cache /share/ntfy/etc /share/ntfy/cache/attachments
CONFIG_PATH=/data/options.json
read_option() {
  key="$1"
  value="$(printenv "$key" 2>/dev/null || true)"
  if [ -n "$value" ]; then
    printf '%s' "$value"
    return 0
  fi
  if [ -f "$CONFIG_PATH" ]; then
    jq -r --arg key "$key" '.[$key] // empty' "$CONFIG_PATH"
  fi
}
BASE_URL="$(read_option base_url)"
UPSTREAM_BASE_URL="$(read_option upstream_base_url || true)"
LISTEN_PORT="$(read_option listen_port)"
if [ -z "$BASE_URL" ]; then
  echo "Error: base_url is not configured" >&2
  exit 1
fi
cat > /share/ntfy/etc/server.yml <<YAML
base-url: "${BASE_URL}"
listen-http: ":${LISTEN_PORT}"
cache-file: "/share/ntfy/cache/cache.db"
attachment-cache-dir: "/share/ntfy/cache/attachments"
auth-file: "/share/ntfy/cache/auth.db"
auth-default-access: "deny-all"
YAML
if [ -n "${UPSTREAM_BASE_URL}" ]; then
  cat >> /share/ntfy/etc/server.yml <<YAML
upstream-base-url: "${UPSTREAM_BASE_URL}"
YAML
fi
echo "Generated ntfy config:"
cat /share/ntfy/etc/server.yml
exec ntfy serve --config /share/ntfy/etc/server.yml

#!/usr/bin/env bash
# Read-only Notion API helper. Fetches a page or database object by ID and
# prints the raw JSON response on stdout.
# Usage: notion_read.sh <page-or-database-id>
# Reads NOTION_TOKEN from environment or os/config/os.env.
# Safe no-op (with local log) when the token is not configured.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_FILE="${REPO_ROOT}/os/config/os.env"
LOG_DIR="${REPO_ROOT}/os/logs"
LOG_FILE="${LOG_DIR}/engine.log"
mkdir -p "${LOG_DIR}"

ID="${1:-}"
if [ -z "${ID}" ]; then
  echo "usage: notion_read.sh <page-or-database-id>" >&2
  exit 2
fi

if [ -z "${NOTION_TOKEN:-}" ] && [ -f "${ENV_FILE}" ]; then
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
fi

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
if [ -z "${NOTION_TOKEN:-}" ]; then
  echo "${TS} | NOTION-UNCONFIGURED | ${ID}" >> "${LOG_FILE}"
  echo "notion token not configured; logged to os/logs/engine.log" >&2
  exit 0
fi

NOTION_VERSION="${NOTION_VERSION:-2022-06-28}"

# Try page endpoint first, then database endpoint on 404.
fetch() {
  local endpoint="$1"
  curl -fsS -m 10 \
    -H "Authorization: Bearer ${NOTION_TOKEN}" \
    -H "Notion-Version: ${NOTION_VERSION}" \
    -w "\n%{http_code}" \
    "https://api.notion.com/v1/${endpoint}/${ID}"
}

RESPONSE=""
HTTP_CODE=""
for endpoint in pages databases; do
  if RAW="$(fetch "${endpoint}" 2>/dev/null)"; then
    HTTP_CODE="$(printf '%s' "${RAW}" | tail -n1)"
    RESPONSE="$(printf '%s' "${RAW}" | sed '$d')"
    if [ "${HTTP_CODE}" = "200" ]; then
      printf '%s\n' "${RESPONSE}"
      echo "${TS} | NOTION-READ-OK | ${ID} | ${endpoint}" >> "${LOG_FILE}"
      exit 0
    fi
  fi
done

HTTP_CODE="${HTTP_CODE:-000}"
echo "${TS} | NOTION-READ-FAILED | ${ID} | ${HTTP_CODE}" >> "${LOG_FILE}"
echo "notion read failed (${HTTP_CODE}); logged" >&2
exit 1

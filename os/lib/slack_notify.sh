#!/usr/bin/env bash
# Post a message to the #company-os Slack channel via incoming webhook.
# Usage: slack_notify.sh "message text"
# Reads SLACK_WEBHOOK_URL from environment or os/config/os.env.
# Safe no-op (with local log) when the webhook is not configured.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_FILE="${REPO_ROOT}/os/config/os.env"
LOG_DIR="${REPO_ROOT}/os/logs"
mkdir -p "${LOG_DIR}"

MSG="${1:-}"
if [ -z "${MSG}" ]; then
  echo "usage: slack_notify.sh \"message\"" >&2
  exit 2
fi

if [ -z "${SLACK_WEBHOOK_URL:-}" ] && [ -f "${ENV_FILE}" ]; then
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
fi

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
if [ -z "${SLACK_WEBHOOK_URL:-}" ]; then
  echo "${TS} | SLACK-UNCONFIGURED | ${MSG}" >> "${LOG_DIR}/notifications.log"
  echo "slack webhook not configured; logged to os/logs/notifications.log" >&2
  exit 0
fi

payload=$(python3 -c 'import json,sys; print(json.dumps({"text": sys.argv[1]}))' "${MSG}")
if curl -fsS -m 10 -X POST -H 'Content-type: application/json' \
     --data "${payload}" "${SLACK_WEBHOOK_URL}" > /dev/null; then
  echo "${TS} | SLACK-SENT | ${MSG}" >> "${LOG_DIR}/notifications.log"
else
  echo "${TS} | SLACK-FAILED | ${MSG}" >> "${LOG_DIR}/notifications.log"
  echo "slack send failed; logged" >&2
  exit 1
fi

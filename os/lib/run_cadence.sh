#!/usr/bin/env bash
# Headless cadence runner — invoked by launchd / cron / Claude Code routines.
#
# Usage: run_cadence.sh <cadence>
#   <cadence> = daily | midweek | weekly | monthly | quarterly
#
# Sets up the same env the user's interactive `claude` shell function uses
# for ~/infinite/* paths (CLAUDE_CONFIG_DIR=~/.claude-icf, codefromhimanshu
# GitHub token), feeds the cadence runbook to `claude -p`, and captures
# stderr to os/logs/engine.log on failure. The runbook itself handles all
# Notion reads, report writes, Slack pings, and log appends.
set -euo pipefail

CADENCE="${1:-}"
case "${CADENCE}" in
  daily|midweek|weekly|monthly|quarterly) ;;
  *)
    echo "usage: run_cadence.sh <daily|midweek|weekly|monthly|quarterly>" >&2
    exit 2 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
RUNBOOK="${REPO_ROOT}/os/engine/cadence_${CADENCE}.md"
LOG_DIR="${REPO_ROOT}/os/logs"
mkdir -p "${LOG_DIR}"

if [ ! -f "${RUNBOOK}" ]; then
  TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "${TS} | ${CADENCE} | run:failed | missing runbook: ${RUNBOOK}" >> "${LOG_DIR}/engine.log"
  exit 1
fi

CLAUDE_BIN="/opt/homebrew/bin/claude"
export CLAUDE_CONFIG_DIR="${HOME}/.claude-icf"
if command -v gh >/dev/null 2>&1; then
  GH_TOKEN="$(gh auth token --user codefromhimanshu 2>/dev/null || true)"
  export GH_TOKEN
fi

cd "${REPO_ROOT}"

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "${TS} | ${CADENCE} | run:start | runbook=${RUNBOOK}" >> "${LOG_DIR}/engine.log"

PROMPT="Execute the runbook at ${RUNBOOK} from working directory ${REPO_ROOT}. Read it, follow it exactly, and do not deviate. You are headless; produce the report file and the Slack ping and the engine.log line as the runbook specifies. Read-only against Notion."

if "${CLAUDE_BIN}" -p "${PROMPT}" >> "${LOG_DIR}/cadence-${CADENCE}.stdout" 2>> "${LOG_DIR}/cadence-${CADENCE}.stderr"; then
  TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "${TS} | ${CADENCE} | run:ok | exit=0" >> "${LOG_DIR}/engine.log"
else
  RC=$?
  TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "${TS} | ${CADENCE} | run:failed | exit=${RC}" >> "${LOG_DIR}/engine.log"
  if [ -x "${SCRIPT_DIR}/slack_notify.sh" ]; then
    "${SCRIPT_DIR}/slack_notify.sh" "${CADENCE} cadence FAILED — see os/logs/cadence-${CADENCE}.stderr (exit ${RC})" || true
  fi
  exit "${RC}"
fi

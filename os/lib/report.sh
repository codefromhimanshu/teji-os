#!/usr/bin/env bash
# Append a section to today's report file under os/reports/.
# Usage: report.sh <cadence-or-skill> <severity> <title> <body>
#   severity ∈ {high, medium, low, clean}
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
LOG_DIR="${REPO_ROOT}/os/logs"
REPORT_DIR="${REPO_ROOT}/os/reports"
LOG_FILE="${LOG_DIR}/engine.log"
mkdir -p "${LOG_DIR}" "${REPORT_DIR}"

if [ "$#" -lt 4 ]; then
  echo "usage: report.sh <cadence-or-skill> <severity> <title> <body>" >&2
  echo "  severity: high | medium | low | clean" >&2
  exit 2
fi

CADENCE="$1"
SEVERITY="$2"
TITLE="$3"
BODY="$4"

case "${SEVERITY}" in
  high|medium|low|clean) ;;
  *)
    echo "usage: report.sh <cadence-or-skill> <severity> <title> <body>" >&2
    echo "  severity must be one of: high, medium, low, clean (got: ${SEVERITY})" >&2
    exit 2
    ;;
esac

DATE="$(date -u +%Y-%m-%d)"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
REPORT_FILE="${REPORT_DIR}/${DATE}-${CADENCE}.md"

# Title-case the cadence label for the header (first letter uppercased).
HEADER_LABEL="$(printf '%s' "${CADENCE}" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"

if [ ! -f "${REPORT_FILE}" ]; then
  {
    printf '# %s report — %s\n\n' "${HEADER_LABEL}" "${DATE}"
    printf -- '---\n\n'
  } > "${REPORT_FILE}"
fi

SEV_UPPER="$(printf '%s' "${SEVERITY}" | tr '[:lower:]' '[:upper:]')"

{
  printf '## [%s] %s\n\n' "${SEV_UPPER}" "${TITLE}"
  printf '%s\n\n' "${BODY}"
  printf -- '---\n\n'
} >> "${REPORT_FILE}"

echo "${TS} | ${CADENCE} | report | ${SEVERITY}: ${TITLE}" >> "${LOG_FILE}"

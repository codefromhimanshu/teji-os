#!/usr/bin/env bash
# Install (or reinstall) the daily + midweek launchd jobs that drive the
# Company OS check engine locally on this Mac.
#
# Usage:
#   os/lib/launchd/install.sh         # install both
#   os/lib/launchd/install.sh daily   # one
#   os/lib/launchd/install.sh midweek
#
# Idempotent: unloads any existing version of the job before loading the new
# plist. Weekly / monthly / quarterly cadences run via Claude Code routines,
# not launchd — see `os/lib/launchd/README.md`.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/Library/LaunchAgents"
mkdir -p "${TARGET_DIR}"

CADENCES=("${@}")
if [ "${#CADENCES[@]}" -eq 0 ]; then
  CADENCES=(daily midweek)
fi

for cadence in "${CADENCES[@]}"; do
  case "${cadence}" in
    daily|midweek) ;;
    *)
      echo "skip: ${cadence} (only daily and midweek run via launchd)" >&2
      continue ;;
  esac

  label="com.companyos.${cadence}"
  src="${SCRIPT_DIR}/${label}.plist"
  dst="${TARGET_DIR}/${label}.plist"

  if [ ! -f "${src}" ]; then
    echo "missing: ${src}" >&2
    exit 1
  fi

  if launchctl list "${label}" >/dev/null 2>&1; then
    launchctl unload "${dst}" 2>/dev/null || true
    echo "unloaded existing ${label}"
  fi

  cp "${src}" "${dst}"
  launchctl load "${dst}"
  echo "loaded ${label} → ${dst}"
done

echo
echo "Verify with: launchctl list | grep companyos"

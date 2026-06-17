#!/usr/bin/env bash
# Install (or reinstall) the launchd jobs that drive the Company OS check
# engine locally on this Mac. All five cadences run via launchd (the cloud
# routines path is dormant — kept in os/engine/routines.md as docs).
#
# Usage:
#   os/lib/launchd/install.sh                  # install all five
#   os/lib/launchd/install.sh daily midweek    # subset
#   os/lib/launchd/install.sh weekly
#
# Idempotent: unloads any existing version of the job before loading the new
# plist.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/Library/LaunchAgents"
mkdir -p "${TARGET_DIR}"

ALL_CADENCES=(daily midweek weekly monthly quarterly)

CADENCES=("${@}")
if [ "${#CADENCES[@]}" -eq 0 ]; then
  CADENCES=("${ALL_CADENCES[@]}")
fi

for cadence in "${CADENCES[@]}"; do
  match=0
  for valid in "${ALL_CADENCES[@]}"; do
    if [ "${cadence}" = "${valid}" ]; then match=1; break; fi
  done
  if [ "${match}" -eq 0 ]; then
    echo "skip: ${cadence} (not one of: ${ALL_CADENCES[*]})" >&2
    continue
  fi

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

# launchd cadences — local schedulers for daily + midweek

These two cadences run locally on this Mac via macOS `launchd`. Weekly,
monthly, and quarterly run in the cloud via Claude Code routines (see
`os/engine/routines.md`) because they're load-bearing — they must run even
if the laptop is asleep.

## Files

- `com.companyos.daily.plist` — Mon–Fri 09:00 local time. Runs
  `os/lib/run_cadence.sh daily`.
- `com.companyos.midweek.plist` — Tue + Thu 14:00 local time. Runs
  `os/lib/run_cadence.sh midweek`.
- `install.sh` — installs both into `~/Library/LaunchAgents/` and
  `launchctl load`s them. Idempotent.

## Install

```bash
bash os/lib/launchd/install.sh           # install both
bash os/lib/launchd/install.sh daily     # just daily
bash os/lib/launchd/install.sh midweek   # just midweek
```

## Verify

```bash
launchctl list | grep companyos
# com.companyos.daily      -    0  (last exit code 0)
# com.companyos.midweek    -    0
```

## Inspect output

```bash
tail -f os/logs/engine.log                  # canonical event log
tail os/logs/launchd-daily.stdout           # last run's stdout
tail os/logs/launchd-daily.stderr           # last run's stderr
ls os/reports/                              # generated reports
```

## Trigger a run by hand (without waiting for the cron)

```bash
launchctl start com.companyos.daily
launchctl start com.companyos.midweek
```

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.companyos.daily.plist
launchctl unload ~/Library/LaunchAgents/com.companyos.midweek.plist
rm ~/Library/LaunchAgents/com.companyos.daily.plist
rm ~/Library/LaunchAgents/com.companyos.midweek.plist
```

## Why these two, not the load-bearing ones

- **Daily** is a quick nudge. If the Mac is asleep Monday 9am, you'll get
  Tuesday's instead — fine.
- **Midweek** is hygiene. Same logic.
- **Weekly/monthly/quarterly** must run on time. The Friday review can't
  silently skip because of a closed lid. Those run in the cloud.

## What it actually does on fire

`launchd` runs `/bin/bash run_cadence.sh <cadence>`. That sets
`CLAUDE_CONFIG_DIR=~/.claude-icf` (to match the interactive shell function),
runs `claude -p "execute the runbook at os/engine/cadence_<cadence>.md"`
headlessly, captures stdout/stderr to `os/logs/`, and appends a
start/ok/fail line to `os/logs/engine.log`. The runbook handles all Notion
reads, the report file, and the Slack ping.

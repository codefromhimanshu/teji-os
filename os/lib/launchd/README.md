# launchd cadences — local schedulers for all five cadences

All five cadences run locally on this Mac via macOS `launchd`. The cloud
routines path (`os/engine/routines.md`) is dormant — kept as docs in case
the Notion claude.ai connector situation improves.

## Files

- `com.companyos.daily.plist` — Mon–Fri 09:00 local. `run_cadence.sh daily`.
- `com.companyos.midweek.plist` — Tue + Thu 14:00 local. `run_cadence.sh midweek`.
- `com.companyos.weekly.plist` — Fri 17:00 local. `run_cadence.sh weekly`.
- `com.companyos.monthly.plist` — 1st of every month 10:00 local. `run_cadence.sh monthly`.
- `com.companyos.quarterly.plist` — Jan/Apr/Jul/Oct 1st 10:00 local. `run_cadence.sh quarterly`.
- `install.sh` — installs the chosen plists into `~/Library/LaunchAgents/`
  and `launchctl load`s them. Idempotent.

## Install

```bash
bash os/lib/launchd/install.sh                  # install all five
bash os/lib/launchd/install.sh daily midweek    # subset
bash os/lib/launchd/install.sh weekly           # just one
```

## Verify

```bash
launchctl list | grep companyos
# com.companyos.daily        -    0
# com.companyos.midweek      -    0
# com.companyos.weekly       -    0
# com.companyos.monthly      -    0
# com.companyos.quarterly    -    0
```

## Inspect output

```bash
tail -f os/logs/engine.log                  # canonical event log
tail os/logs/launchd-<cadence>.stdout       # last run's stdout
tail os/logs/launchd-<cadence>.stderr       # last run's stderr
ls os/reports/                              # generated reports
```

## Trigger a run by hand (without waiting for the cron)

```bash
launchctl start com.companyos.daily
launchctl start com.companyos.weekly
# etc.
```

## Uninstall (one)

```bash
launchctl unload ~/Library/LaunchAgents/com.companyos.<cadence>.plist
rm ~/Library/LaunchAgents/com.companyos.<cadence>.plist
```

## Uninstall (all five)

```bash
for c in daily midweek weekly monthly quarterly; do
  launchctl unload ~/Library/LaunchAgents/com.companyos.${c}.plist 2>/dev/null || true
  rm -f ~/Library/LaunchAgents/com.companyos.${c}.plist
done
```

## Sleep-skip risk + mitigation

`launchd` cron only fires while the Mac is awake. If the laptop is asleep
at the scheduled time, the run is **skipped, not deferred**. The risk
matrix:

| Cadence    | Skip impact | Mitigation                                   |
|------------|-------------|----------------------------------------------|
| daily      | low         | next morning catches up                      |
| midweek    | low         | hygiene only                                 |
| weekly     | **high**    | set wake-on-schedule for Fri 16:55           |
| monthly    | high        | wake-on-schedule 1st of month 09:55          |
| quarterly  | high        | wake-on-schedule Jan/Apr/Jul/Oct 1st 09:55   |

To set wake-on-schedule:
**System Settings → Battery → Schedule** (older macOS), or
`sudo pmset repeat wakeorpoweron MTWRF 08:55:00` for daily wake.

For the load-bearing cadences (weekly+), I'd recommend at least the Friday
wake-on-schedule. Five minutes of laptop on Friday afternoon is cheap
insurance for the accountability loop.

## Why launchd, not Claude Code cloud routines

The cloud routines path needs the Notion MCP available as a claude.ai
"connector" (not the same surface as the chat-side Notion integration).
At time of writing, attempts to attach Notion to the routines came back
with the connector not visible in the routines API. `launchd` runs in
your local shell environment where the interactive `/mcp` Notion auth is
already valid, so it just works.

If/when Notion appears as a routine-compatible connector, you can flip the
load-bearing cadences back to cloud via `os/engine/routines.md`.

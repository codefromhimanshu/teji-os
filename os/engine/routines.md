# Cloud routines — weekly + monthly + quarterly

These three cadences run via Claude Code's `/schedule` (a.k.a. routines) so
they fire reliably regardless of the laptop's state. Daily and midweek run
locally via `launchd` (`os/lib/launchd/`); only the load-bearing,
must-not-miss cadences live in the cloud.

## The contract — identical to local runs

The cloud agent reads the same runbook from this repo (cloned at run time),
follows the engine contract (read-only against Notion), writes the report to
`os/reports/`, appends to `os/logs/engine.log`, and sends one Slack ping.
Nothing about the engine's behavior changes; only the launcher does.

## Three routines to register

Invoke the `schedule` skill once per cadence with the following config:

### weekly-review
- **Cron:** `0 17 * * 5` — Fridays at 17:00 local
- **Prompt:**
  > Working directory is `~/infinite/company-os`. Execute the runbook at
  > `os/engine/cadence_weekly.md` end-to-end: snapshot Notion via os-sync,
  > run all weekly checks, produce the full Weekly Review draft at
  > `os/reports/<YYYY-MM-DD>-weekly-review.md`, send the Gmail digest (Slack
  > fallback), send the Slack summary, append to `os/logs/engine.log`.
  > Read-only against Notion. Never write to Notion. Never self-close the
  > review. Never soften misses. Never skip the violations section.

### monthly-audit
- **Cron:** `0 10 1 * *` — 1st of every month at 10:00 local
- **Prompt:**
  > Working directory is `~/infinite/company-os`. Execute the runbook at
  > `os/engine/cadence_monthly.md`: snapshot Notion, run all monthly
  > checks, produce `os/reports/<YYYY-MM>-monthly-audit.md` with the four
  > sections (strategy staleness, killed-idea patterns, failed-experiment
  > patterns, hygiene), Slack the top 3 findings, append to engine.log.
  > Read-only against Notion. Drafts only — never set Approved / Scaled,
  > never edit Constitution or Strategy.

### quarterly-audit
- **Cron:** `0 10 1 1,4,7,10 *` — 1st of Jan/Apr/Jul/Oct at 10:00 local
- **Prompt:**
  > Working directory is `~/infinite/company-os`. Execute the runbook at
  > `os/engine/cadence_quarterly.md`: deepest check. Produce
  > `os/reports/<YYYY-QQ>-quarterly-audit.md` covering the four sections
  > plus the heaviest rule (judgment-on-the-table: if ≥3 consecutive clean
  > kills with the process holding, write it plainly per the Constitution).
  > Slack top 3 findings. Append to engine.log. Read-only against Notion.
  > Never soften the judgment-on-the-table check.

## How to register

In a Claude Code session in this repo, invoke the `schedule` skill three
times with the cron + prompt for each cadence above. Confirm registration
with the routines panel.

## How to verify a routine fires correctly

After the first scheduled run, check:

```bash
ls -la os/reports/                  # new report file with today's date
tail os/logs/engine.log             # run:start + run:ok lines
git log --oneline os/reports/       # report should be committable
```

## How to roll back

In Claude Code, delete the routine via the schedule skill. The runbook stays
in the repo (it works fine when invoked by hand too).

## Why these three live in the cloud, not launchd

- **Weekly review is the spine of the accountability loop** (Principle 11 —
  the work stays visible). A skipped Friday review breaks the loop.
- **Monthly + quarterly audits are infrequent enough** that a missed run is
  hard to recover (no "I'll run yesterday's tomorrow" — the data window is
  the calendar month/quarter). Cloud cron makes this robust.
- **Daily + midweek are forgiving** — they're nudges + hygiene, not
  reckonings. Local launchd is plenty.

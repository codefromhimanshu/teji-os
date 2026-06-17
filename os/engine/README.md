# Company OS — Mechanical Check Engine

The engine is the read-only heart of the Company OS. It reads Notion (via
local snapshots and direct fetches by ID), evaluates every check listed in
`os/config/checks.yaml`, writes a markdown report to `os/reports/`, sends
one consolidated Slack ping, and appends one line per action to
`os/logs/engine.log`. The humans read the report and update Notion. The
engine never does.

## The contract (non-negotiable)

- **Read-only against Notion.** No `notion-create-*`, `notion-update-*`,
  `notion-move-*`, `notion-duplicate-*`, `notion-create-comment`,
  `notion-create-view`, `notion-update-view`. Banned, every cadence, every
  skill, every run.
- **Write-only locally.** The engine writes three places and three places
  only: `os/reports/<date>-<cadence>.md`, `os/logs/engine.log`, and the
  Slack channel via `os/lib/slack_notify.sh`.
- **No silent failures.** Capability probe at start; any failure gets a
  Slack ping ("`<cadence>`: Notion unreachable — run skipped") and a log
  line, then the run exits.
- **One consolidated Slack ping per run.** Not one per check. The headline
  and a link/path to today's report.
- **Audit trail.** Every action — file write, Slack send, exit reason —
  appends one line to `os/logs/engine.log` in the format
  `[ISO timestamp] | <cadence> | <action> | <outcome>`.

## What it does

For a given cadence (daily, midweek, weekly, monthly, quarterly):

1. Read `principles/ai-operating-rules.md` and this README.
2. Capability probe: read `company_os_page` from
   `os/config/notion-ids.json`. On failure: Slack the failure, log it, exit.
3. Refresh local snapshot of Notion (`os-sync` skill) into `os/mirrors/`.
4. Filter `os/config/checks.yaml` to checks whose `cadence` includes the
   current cadence.
5. For each check: query the snapshot (or fetch the named view by ID), apply
   the rule, and if it fires, add a row to today's report under the right
   section.
6. For cadences with a skill output (daily-focus briefing, weekly review
   draft, monthly/quarterly audit findings), append that output into the
   same report under its own section.
7. Write `os/reports/<YYYY-MM-DD>-<cadence>.md` (or `<YYYY-MM>-monthly-audit.md`,
   `<YYYY-QQ>-quarterly-audit.md`).
8. If any check fired: send one consolidated Slack ping listing the count
   per section and the report path. Otherwise: send one "all green" line.
9. Append a summary line to `os/logs/engine.log`.

## Where outputs land

| Output | Path |
|---|---|
| Check list (source of truth) | `os/config/checks.yaml` |
| Cadence runbooks | `os/engine/cadence_*.md` |
| Single-check procedure | `os/engine/run_check.md` |
| Daily / midweek / weekly reports | `os/reports/YYYY-MM-DD-<cadence>.md` |
| Monthly audit | `os/reports/YYYY-MM-monthly-audit.md` |
| Quarterly audit | `os/reports/YYYY-QQ-quarterly-audit.md` |
| Snapshot of Notion (read by engine) | `os/mirrors/` |
| Audit log (append-only) | `os/logs/engine.log` |
| Slack | via `os/lib/slack_notify.sh "<message>"` |

## Relationship to skills

`os/skills/*/SKILL.md` still contain the AI logic (idea-review,
daily-focus, weekly-review, principle-check, marketing-review,
decision-log, os-sync, os-bootstrap). The engine cadences in this
directory call those skills as read-only producers — the skills emit
markdown that gets pasted into today's report; nothing writes Notion.

`os/agents/*.md` are deprecated. The five `cadence_*.md` files here replace
them.

## How to run a cadence

Each cadence runbook is self-contained and starts with the capability
probe. To execute by hand:

```
# Daily (Mon–Fri 09:00):
follow os/engine/cadence_daily.md

# Midweek (Tue + Thu 14:00):
follow os/engine/cadence_midweek.md

# Weekly (Fri 17:00):
follow os/engine/cadence_weekly.md

# Monthly (1st 10:00):
follow os/engine/cadence_monthly.md

# Quarterly (Jan/Apr/Jul/Oct 1st 10:00):
follow os/engine/cadence_quarterly.md
```

The cron registrations live in `os/config/cadences.md`; update those to
point at `os/engine/cadence_*.md` once the old `os/agents/*.md` files are
retired.

## Cross-links

- `principles/ai-operating-rules.md` — the contract
- `principles/company-constitution.md` — the 13 Principles
- `os/config/checks.yaml` — every check the engine knows
- `os/config/notion-ids.json` — address-by-ID, never search
- `os/engine/run_check.md` — single-check procedure
- `os/logs/engine.log` — append-only audit trail
- `os/reports/` — what the human reads
- `os/mirrors/` — snapshot of Notion the engine queries

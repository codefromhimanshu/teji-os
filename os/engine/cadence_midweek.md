# cadence_midweek — Tue + Thu 14:00

Replaces `os/agents/midweek-check.md`. Read-only against Notion. Output
is local markdown + one Slack ping. No Notion writes.

## 0. Required reading

1. Read `principles/ai-operating-rules.md` and the engine contract in
   `os/engine/README.md`.
2. Capability probe: read `company_os_page` ID from
   `os/config/notion-ids.json`. On failure → Slack ping
   `midweek-check: Notion unreachable — run skipped`, append failure line
   to `os/logs/engine.log`, exit.

## 1. Snapshot

Run `os-sync` (read-only) to refresh `os/mirrors/`. All checks below run
against the snapshot + named view fetches by ID.

## 2. Run filtered checks

Load `os/config/checks.yaml`. Filter to checks where `midweek` is in
`cadence`. For each, follow `os/engine/run_check.md`. The midweek set is
the Needs-Attention pass:

- `bet_running_no_window` (Principle 4, high)
- `bet_verdict_no_end_date` (Principle 11, medium)
- `bet_verdict_no_learning` (Principle 11, high — Principle 11 names
  learnings as the visibility output)
- `bet_no_status` (Principle 11, medium)
- `task_done_no_consumed_sp` (Principle 11, medium)
- `task_started_no_started_date` (Principle 11, medium)
- `task_no_committed_sp` (Principle 11, medium)
- `task_blocked_no_reason` (Principle 11, medium)
- `task_no_status` (Principle 11, medium)
- `shaping_bets_overflow` (Principle 2/3, high — >2 in Shaping)
- `experiments_past_window` (Principle 4, high)
- `decisions_past_review_date` (Principle 8, high — Enforcement Level 5)
- `ideas_stuck_evaluating` (Principle 5, medium)
- `experiment_no_update_7d` (Principle 11, high)

For each fired check, the report row uses the format in `run_check.md`,
naming the violated principle by number and the exact action the human
must take in Notion.

## 3. Write the report

Write `os/reports/<YYYY-MM-DD>-midweek.md`:

```
# Midweek Check — <YYYY-MM-DD>

## Needs Attention — bets
- <fired rows>

## Needs Attention — tasks
- <fired rows>

## Ongoing duties
- <shaping overflow, stuck ideas, etc.>

## Principle 8 — decisions past review
- <fired rows; Enforcement Level 5 — chase until human fills in>

## Principle 11 — visibility
- <experiments with no update in 7d>

## Clean checks
- <ids>
```

## 4. Slack — one consolidated ping

If >3 items fired, send one combined Slack message via
`os/lib/slack_notify.sh`:

```
Midweek <date>: <N> items need attention (<bets-count> bets, <tasks-count> tasks, <decisions-count> decisions past review). Report: os/reports/<YYYY-MM-DD>-midweek.md
```

If 0 items fired, send a one-line OK.

## 5. Log + exit

Append to `os/logs/engine.log`:

```
[ISO ts] | midweek | run:complete | fired:<n> clean:<m>
```

NEVER write to Notion.

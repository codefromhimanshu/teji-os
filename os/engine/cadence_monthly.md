# cadence_monthly — 1st of month 10:00

Replaces `os/agents/monthly-audit.md`. Read-only against Notion. Output
is a local markdown audit + one Slack ping with the top findings. No
Notion writes.

## 0. Required reading

1. Read `principles/ai-operating-rules.md` and the engine contract in
   `os/engine/README.md`.
2. Capability probe: read `company_os_page` ID from
   `os/config/notion-ids.json`. On failure → Slack ping
   `monthly-audit: Notion unreachable — run skipped`, append failure line
   to `os/logs/engine.log`, exit.

## 1. Snapshot

Run `os-sync` to refresh `os/mirrors/`. Pull Current Strategy, Ideas
(all statuses), Experiments / Bets (all statuses + verdicts), Decision
Log (all entries), Weekly Reviews for the month.

## 2. Run filtered checks

Load `os/config/checks.yaml`. Filter to checks where `monthly` is in
`cadence`. For each, follow `os/engine/run_check.md`. Monthly set:

- `strategy_review_overdue` (Principle 8, high — Current Strategy review
  date passed)
- `active_experiment_off_focus` (Principle 2, high — active experiment
  not consistent with Current Focus)
- `killed_idea_pattern` (computed — ≥3 killed ideas this month with the
  same reason)
- `reach_failure_count` (Principle 6, high — reach vs product failures
  this month; reach failure sank the company last time)
- `idea_no_status` (Principle 11, medium)
- `experiment_no_stop_rule` (Principle 4, high)
- `decision_no_review_date` (Principle 8, medium)

For each fired check, name the principle by number and surface the
recurring pattern explicitly — patterns are the point of the monthly.

## 3. Write the report

Write `os/reports/<YYYY-MM>-monthly-audit.md`:

```
# Monthly Audit — <YYYY-MM>

> Status: NEEDS HUMAN. The human reads and decides. Engine never sets
> status.

## 1. Strategy staleness
- <strategy_review_overdue>
- <active_experiment_off_focus>

## 2. Killed-idea patterns
- <recurring reasons; same channel / segment / assumption>

## 3. Failed-experiment patterns
- Reach failures: <count>  (the one that sank us last time — Principle 6)
- Product failures: <count>
- <pattern notes>

## 4. Hygiene
- Ideas without status: <list>
- Experiments without stop rules: <list>
- Decisions without review dates: <list>

## Checks fired
- <run_check.md format>

## Clean checks
- <ids>
```

## 4. Slack — top 3 findings

One consolidated Slack ping via `os/lib/slack_notify.sh`:

```
Monthly audit <month>: top findings — 1) <finding>. 2) <finding>. 3) <finding>. Report: os/reports/<YYYY-MM>-monthly-audit.md
```

The full audit is in the report; Slack is the alert.

## 5. Log + exit

Append to `os/logs/engine.log`:

```
[ISO ts] | monthly | run:complete | fired:<n> clean:<m>
```

NEVER write to Notion.

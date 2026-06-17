# cadence_quarterly — Jan/Apr/Jul/Oct 1st 10:00

Replaces `os/agents/quarterly-audit.md`. The deepest check. Includes the
heaviest rule — the judgment-on-the-table check. Read-only against
Notion. No Notion writes.

## 0. Required reading

1. Read `principles/ai-operating-rules.md` and the engine contract in
   `os/engine/README.md`.
2. Capability probe: read `company_os_page` ID from
   `os/config/notion-ids.json`. On failure → Slack ping
   `quarterly-audit: Notion unreachable — run skipped`, append failure
   line to `os/logs/engine.log`, exit.

## 1. Snapshot

Run `os-sync` to refresh `os/mirrors/`. For the quarter: every Decision
Log entry, every Weekly Review, every Experiment + verdict (read
`~/infinite/principles/experiment-log.md` if present), Marketing Library
changes, Ideas killed.

## 2. Run filtered checks

Load `os/config/checks.yaml`. Filter to checks where `quarterly` is in
`cadence`. For each, follow `os/engine/run_check.md`. Quarterly set:

- `principle_never_invoked` (high — any of the 13 not cited in any
  Decision Log entry this quarter)
- `violation_trend_top_principle` (high — principle most violated this
  quarter; is enforcement working or being routed around?)
- `operating_rule_friction` (high — operating rules repeatedly causing
  friction; draft an amendment proposal per the Constitution)
- `judgment_on_table` (CRITICAL — ≥3 consecutive clean kills with the
  process holding → write the heaviest-rule line plainly; do not soften)
- `strategy_review_overdue` (Principle 8, high)
- `reach_failure_count` (Principle 6, high)
- `killed_idea_pattern` (high)

## 3. The heaviest rule — judgment on the table

If `judgment_on_table` fires (≥3 consecutive clean kills, process held),
write this line plainly into the report under section 4. Do not soften:

> The process is holding; the bets keep dying. Per the Constitution, the
> founder's judgment — the assumptions generating these bets — goes on
> the table next. Recommend a written assumptions review.

If it does not fire, the section still exists and says "Not triggered
this quarter (consecutive clean kills: <n>)."

## 4. Write the report

Write `os/reports/<YYYY-QQ>-quarterly-audit.md` (e.g.
`2026-Q2-quarterly-audit.md`):

```
# Quarterly Audit — <YYYY> <Qn>

> Status: NEEDS HUMAN. The deepest check. Engine never sets status.

## 1. Are the principles real or theoretical?
For each of the 13: cite where it was applied this quarter, or
"never invoked". A principle never invoked is either being silently
followed or silently ignored — say which, with evidence from the
Decision Log and Weekly Reviews.

- Principle 1: <citations | never invoked + reasoning>
- ... (all 13)

## 2. Violation trends
- Principle most violated this quarter: <n>
- Is enforcement working or being routed around? <evidence>
- Aggregate weekly violation counts: <table>

## 3. Operating-rules friction
- <rules repeatedly causing friction>
- Draft amendment proposal (per Constitution's amendment process — put
  in writing → founder decides → change logged). DRAFT only:
  <one-paragraph proposal>

## 4. Judgment on the table (the heaviest rule)
- Consecutive clean kills this quarter: <n>
- Process held: <yes/no>
- <If ≥3 with process holding: the heaviest-rule line, verbatim>
- <Else: "Not triggered this quarter">

## Checks fired
- <run_check.md format>

## Clean checks
- <ids>
```

## 5. Slack — alert

One consolidated Slack ping via `os/lib/slack_notify.sh`:

```
Quarterly audit <YYYY-Qn>: principles-never-invoked <n>, top-violated P<n>, judgment-on-table <triggered|clear>. Report: os/reports/<YYYY-QQ>-quarterly-audit.md
```

If `judgment_on_table` fires, the Slack ping leads with it:
```
Quarterly audit <YYYY-Qn>: JUDGMENT ON THE TABLE — <n> consecutive clean kills, process held. Read the report. Report: os/reports/<YYYY-QQ>-quarterly-audit.md
```

## 6. Log + exit

Append to `os/logs/engine.log`:

```
[ISO ts] | quarterly | run:complete | fired:<n> clean:<m> judgment_on_table:<triggered|clear>
```

NEVER write to Notion.

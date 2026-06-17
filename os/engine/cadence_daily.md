# cadence_daily — Mon–Fri 09:00

Replaces `os/agents/daily-focus.md`. Read-only against Notion. Output is
local markdown + one Slack ping. No Notion writes.

## 0. Required reading

1. Read `principles/ai-operating-rules.md` and the engine contract in
   `os/engine/README.md`.
2. Capability probe: read `company_os_page` ID from
   `os/config/notion-ids.json`. On failure → Slack ping
   `daily-focus: Notion unreachable — run skipped`, append failure line
   to `os/logs/engine.log`, exit.

## 1. Snapshot

Run the `os-sync` skill in read-only mode to refresh `os/mirrors/` from
Notion. This is the engine's only Notion contact for the rest of the run.

## 2. Skill output: daily focus briefing

Execute the `daily-focus` skill at `os/skills/daily-focus/SKILL.md`
against the snapshot only. It produces, as markdown:

- **Top 3 priorities today** — each tied to the active experiment's
  hypothesis or an overdue obligation.
- **Avoid today** — distractions from the current bet (Principle 2).
- **Principle most at risk today** — by number, one line why.
- **Waiting on human** — count + the single most important one.
- **Window math** — if any active experiment window ends within 2 days,
  surface it.

This block is the lead section of today's report; the human reads it and
acts.

## 3. Run filtered checks

Load `os/config/checks.yaml`. Filter to checks where `daily` is in
`cadence`. For each, follow `os/engine/run_check.md`. Daily check set:

- `bet_running_no_window` (Principle 4, high)
- `task_done_no_consumed_sp` (Principle 11, medium)
- `task_started_no_started_date` (Principle 11, medium)
- `bet_no_status` (Principle 11, medium)
- `task_no_status` (Principle 11, medium)
- `task_blocked_no_reason` (Principle 11, medium)
- `task_no_committed_sp` (Principle 11, medium)
- `experiment_window_closing_2d` (Principle 4, high — computed)
- `principle_most_at_risk_today` (computed — from skill output)

Treat the daily-focus skill's "principle most at risk" as the
`principle_most_at_risk_today` check entry; it is always present and
always reported.

## 4. Write the report

Write `os/reports/<YYYY-MM-DD>-daily.md` with sections:

```
# Daily Focus — <YYYY-MM-DD>

## Today's 3 priorities
<from skill>

## Avoid today
<from skill>

## Principle most at risk
<from skill — principle number + one-line reason>

## Waiting on human
<count + top one>

## Checks fired
- <one bullet per row that fired, per run_check.md format>

## Clean checks
- <one line per clean check id>
```

If a window closes within 2 days, raise it as the lead line under
"Today's 3 priorities" — verdict prep beats new work (Principle 4).

## 5. Slack — headline only

One Slack ping via `os/lib/slack_notify.sh`. Format:

```
Daily focus <date>: <top priority>. <N> checks fired. Report: os/reports/<YYYY-MM-DD>-daily.md
```

Keep it under 15 lines. The full briefing is in the report; Slack is the
nudge.

## 6. Log + exit

Append to `os/logs/engine.log`:

```
[ISO ts] | daily | run:complete | fired:<n> clean:<m>
```

NEVER write to Notion.

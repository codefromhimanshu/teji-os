---
name: daily-focus
description: >
  Morning chief-of-staff briefing: read Constitution, Current Strategy, active
  Experiments, and open Ideas; produce today's 3 priorities, the avoid-list,
  and the principle most at risk. Trigger on "daily focus", "what should we
  focus on today", or the scheduled weekday-morning run.
---

# Daily Focus

Keep it short. The output is a briefing, not a report.

## Process

1. Probe Notion access (read Company OS page by ID from
   `os/config/notion-ids.json`). Headless + failure → report via
   `os/lib/slack_notify.sh` and exit (see ai-operating-rules: capability probe).
2. Read: Current Strategy (Current Focus + Ignoring-for-now), active
   Experiments (windows, success bars, days remaining), Ideas in
   Evaluating/Validating, decisions past Review Date, items in Needs-Human
   states.
3. Produce:
   - **Top 3 actions today** — each tied to the active experiment's hypothesis
     or an overdue obligation (verdict due, outcome unfilled). Not busywork.
   - **Avoid today** — open items that are distractions from the current bet
     (Principle 2), named.
   - **Principle most at risk today** — by number, one line why.
   - **Waiting on human** — count + the single most important one.
4. Days-remaining math: if an experiment window ends within 2 days, say so —
   verdict prep beats new work.

## Output

- Post the briefing to Slack via `os/lib/slack_notify.sh`.
- Interactive runs: print it; offer to update Next Action fields in Notion.
- Append to AI Activity Log (one line).

---
name: daily-focus
description: >
  Morning chief-of-staff briefing: read Constitution, Current Strategy, active
  Experiments, and open Ideas; produce today's 3 priorities, the avoid-list,
  and the principle most at risk. Trigger on "daily focus", "what should we
  focus on today", or the scheduled weekday-morning run.
---

# Daily Focus

Keep it short. The output is a briefing, not a report. **You are read-only
against Notion.** The full briefing goes to a markdown file; Slack gets only
the headline.

## Process

1. Probe Notion access (read Company OS page by ID from
   `os/config/notion-ids.json`). Headless + failure → report via
   `os/lib/slack_notify.sh` and exit (see ai-operating-rules: capability probe).
2. Read: Current Strategy (Current Focus + Ignoring-for-now), active
   Experiments (windows, success bars, days remaining), Ideas in
   Evaluating/Validating, decisions past Review Date, items in Needs-Human
   states. Read-only access only.
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

Write a single markdown file at `os/reports/<YYYY-MM-DD>-daily.md`:

```
# Daily Focus — <YYYY-MM-DD>

## Top 3 Actions Today
1. <action> — tied to: <experiment / overdue obligation>
2. <action> — tied to: <...>
3. <action> — tied to: <...>

## Avoid Today
- <distraction> (Principle 2)
- <distraction>

## Principle Most At Risk
P# — <one line why>

## Waiting On Human
Count: <N>
Top item: <name + ask>

## Experiments Window Watch
- <experiment>: <N> days remaining, success bar <metric>, status <one line>
```

- **Slack**: post the headline only (≤15 lines) via
  `os/lib/slack_notify.sh`. Headline = top 3 actions + principle-most-at-risk
  + waiting-on-human count + a "see os/reports/<file>" line.
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | daily-focus | wrote <report path> | top1=<one line>`.

## Hard rules

- Never call any Notion write tool. The markdown report and Slack are the
  only output channels.
- Never extend the briefing past one screen of Slack.

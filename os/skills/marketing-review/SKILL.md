---
name: marketing-review
description: >
  Review a marketing idea or campaign against the Marketing Rules, Company
  Constitution, and Current Strategy before anything runs. Trigger on "review
  this campaign", "marketing idea", "should we post/run/promote", or any
  Marketing Library entry entering Testing.
---

# Marketing Review

Apply `principles/ai-operating-rules.md`. No campaign runs without a
measurable hypothesis. **You are read-only against Notion.** Output a
markdown report; the human applies the row to Notion.

## Marketing rules (enforced)

1. No marketing idea is approved without a target customer.
2. No campaign runs without a measurable hypothesis and success metric.
3. No ad is evaluated emotionally; metrics only.
4. No positioning changes after one weak result (Principle 4: the bar does not
   move; also Constitution: no emotional strategy changes).
5. No paid acquisition before product signal (Principle 7).
6. Premium positioning is not diluted by discount messaging without explicit
   human approval.

## Process

1. Read `strategy/current-strategy.md` (channels, positioning) and any
   positioning.md from the active experiment dir
   (`~/infinite/principles/experiments/<active>/positioning.md`).
2. Check: target customer, message clarity, offer strength, positioning fit,
   success metric, stop rule, budget risk.
3. If it should run, it is an **experiment**: spec it with hypothesis,
   channel, metric, success rule, stop rule, budget, window — the human will
   create the Experiments DB row from the report block.
4. Anything with spend → recommend Needs Human (permission model: committing
   money is human-only).

## Output

Write a single markdown file at
`os/reports/<YYYY-MM-DD>-marketing-review-<slug>.md`:

```
# Marketing Review — <campaign / idea name>

## Recommended Notion Updates
Target DB: Marketing Library (id: see os/config/notion-ids.json)
Row: <existing or "create new">
- Type: <Positioning | Persona | Hook | Ad Angle | Offer | Landing Copy | ...>
- Status: <Raw | Testing | Needs Human | Parked>
  (Approved/Scaled are human-only — never recommend those)
- Channel: <one>
- Target Customer: <one line>
- Evidence: <tagged [Data]/[Estimate]/[Assumption]>
- Principle Check: <Passed | Failed | Needs Review>
- AI Notes: <one paragraph>

## AI Review
(standard format: target customer, hypothesis, metric, success rule, stop
rule, budget, positioning fit, principle check by number, recommendation,
confidence, reasoning, what would change my mind.)

## If Approved For Test
Experiments DB row to copy:
- Experiment: <title>
- Status: Planned
- Hypothesis: <one line>
- Channel: <one>
- Metric: <one>
- Success Rule: <one>
- Stop Rule: <one>
- Budget: <number>
- Start / End Date: <window>
```

- **Slack**: ping via
  `os/lib/slack_notify.sh "MARKETING: <name> — <ask> — see os/reports/<file>"`
  for any Needs Human state or any spend recommendation.
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | marketing-review | wrote <report path> | <verdict>`.

## Hard rules

- Never call any Notion write tool. The report and Slack are the only output
  channels.
- Never recommend bypassing the measurable-hypothesis rule.

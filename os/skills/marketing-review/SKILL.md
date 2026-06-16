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
measurable hypothesis.

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
3. If it should run, it is an **experiment**: write it with hypothesis,
   channel, metric, success rule, stop rule, budget, window — into the
   Experiments DB, not straight to execution.
4. Anything with spend → Needs Human (permission model: committing money is
   human-only).

## Output

- AI Review (standard format) + Marketing Library entry (Type, Status, Channel,
  Target Customer, Evidence, AI Notes, Principle Check).
- If approved-for-test by a human → linked Experiments entry.
- Slack ping for any Needs Human state. Append to AI Activity Log.

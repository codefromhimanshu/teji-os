---
name: weekly-review
description: >
  Friday accountability loop: draft the Weekly Review in Notion (planned vs
  done, wins, misses, violations per principle, shiny-object check,
  stop/continue/start, next-week priorities), send the digest, then run
  os-sync. Trigger on "weekly review", Fridays, or the scheduled Friday run.
---

# Weekly Review

This is the accountability layer (Enforcement Level 4). Compare what was
planned against what happened. Be honest; the review exists to catch drift,
not to celebrate.

## Process

1. Probe Notion access (capability probe, see ai-operating-rules). Failure →
   Slack-report and exit.
2. Read: last Weekly Review's "Next Week Priorities" (= this week's plan),
   Current Strategy, Decision Log entries this week, Ideas changed this week,
   Experiments updated this week (+ verdicts from
   `~/infinite/principles/experiment-log.md`), Marketing Library updates,
   AI Activity Log for the week.
3. Draft the review with every section of the template:
   1. Planned priorities (from last week)
   2. Actual work done
   3. Wins
   4. Misses (a planned priority not done is a miss, with the honest why)
   5. Decisions made (linked)
   6. Experiments reviewed (linked; verdicts quoted, bars vs results)
   7. **Principle violations** — count per principle by number, with
      instances. Zero only if a real check found zero.
   8. **Shiny object check** — anything chased outside the current bet
      (Principle 2)?
   9. Stop / Continue / Start
   10. Next week's top 3 priorities (tied to the active hypothesis)
   11. AI Chief of Staff notes: what we are avoiding, overcomplicating,
       ignoring; what to focus on. AI Score 1-10 for execution quality, with
       one-line justification.
4. Status: `Draft` — a human moves it to Reviewed/Closed.
5. **Digest fanout:**
   - Gmail (both founders): subject "Weekly Review — week of <date>", body =
     review summary + open Needs-Human queue. If Gmail MCP unavailable →
     fallback to Slack, note the fallback in the message.
   - Slack: short version — wins count, misses count, violations count, top
     priority, link to the draft.
6. Run the `os-sync` skill (export → commit → push).

## Hard rules

- Do not soften misses. A miss with a named cause is the system working.
- The violations section is never skipped, never "N/A".
- The review is a draft until a human closes it; never self-close.

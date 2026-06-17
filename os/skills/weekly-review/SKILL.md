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
not to celebrate. **You are read-only against Notion.** The full draft lands
as a markdown report; the human creates the Notion Weekly Reviews row by
copying from it.

## Process

1. Probe Notion access (capability probe, see ai-operating-rules). Failure →
   Slack-report and exit. Read-only access only.
2. Read: last Weekly Review's "Next Week Priorities" (= this week's plan),
   Current Strategy, Decision Log entries this week, Ideas changed this week,
   Experiments updated this week (+ verdicts from
   `~/infinite/principles/experiment-log.md`), Marketing Library updates,
   `os/logs/engine.log` for the week.
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
4. Recommend status `Draft` — a human creates the row and moves it to
   Reviewed/Closed themselves.
5. **Digest fanout:**
   - Gmail (both founders): subject "Weekly Review — week of <date>", body =
     review summary + open Needs-Human queue + link to the markdown report.
     Gmail is not Notion — Gmail writes are still allowed. If Gmail MCP
     unavailable → fallback to Slack, note the fallback in the message.
   - Slack: short version — wins count, misses count, violations count, top
     priority, link to the report file.
6. Run the `os-sync` skill (read-only export → commit → push). os-sync is
   itself read-only from Notion.

## Output

Write a single markdown file at
`os/reports/<YYYY-MM-DD>-weekly-review.md`:

```
# Weekly Review — week of <YYYY-MM-DD>

## Recommended Notion Updates
Target DB: Weekly Reviews (id: see os/config/notion-ids.json)
Row: create new
- Week: <ISO week>
- Start / End Date: <range>
- Status: Draft   (Reviewed/Closed are human-only)
- Main Focus: <one line>
- AI Score: <1-10>
- Decisions Made: <relations to add by hand>
- Experiments Completed: <relations to add by hand>

## 1. Planned Priorities (last week's "Next Week" list)
- <p1>
- <p2>
- <p3>

## 2. Actual Work Done
- ...

## 3. Wins
- ...

## 4. Misses
- <priority not done> — honest why: <...>

## 5. Decisions Made
- <link/title> — <one line>

## 6. Experiments Reviewed
- <name> — bar: <metric>, result: <actual>, verdict: <quote>

## 7. Principle Violations (count by number)
P1: <N> — <instance>
P2: <N> — <instance>
...
P13: <N> — <instance>
Total P0: <N>

## 8. Shiny Object Check (Principle 2)
<what was chased outside the bet, or "none">

## 9. Stop / Continue / Start
- Stop: ...
- Continue: ...
- Start: ...

## 10. Next Week's Top 3 Priorities
1. ... (tied to active hypothesis: <one line>)
2. ...
3. ...

## 11. AI Chief of Staff Notes
- Avoiding: ...
- Overcomplicating: ...
- Ignoring: ...
- Focus: ...
- AI Score: <1-10> — <one-line justification>
```

- **Slack**: short summary via `os/lib/slack_notify.sh`.
- **Gmail**: digest as above. Gmail writes remain allowed.
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | weekly-review | wrote <report path> | wins=<N> misses=<N> violations=<N>`.

## Hard rules

- Do not soften misses. A miss with a named cause is the system working.
- The violations section is never skipped, never "N/A".
- The review is a draft until a human closes it; never self-close. The
  skill never creates or updates the Notion row — only the human does.
- Never call any Notion write tool. The markdown report, Slack, and Gmail are
  the only output channels.

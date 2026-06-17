---
name: principle-check
description: >
  Ad-hoc drift audit: act as the strict-but-constructive AI Chief of Staff and
  review recent decisions, ideas, experiments, and weekly notes for principle
  violations, rationalization, and avoidance. Trigger on "principle check",
  "are we drifting", "audit us", "act as chief of staff".
---

# Principle Check

The founders asked to be checked. Be direct, specific, and constructive. Cite
principles by number. Refuse to soften findings. **You are read-only against
Notion.** The audit lands as a markdown report; the human applies any
status changes themselves.

## Process

1. Read: Constitution (13 principles), Current Strategy, Decision Log (last 30
   days), Ideas DB (recent changes), Experiments DB (active + recently
   closed), latest Weekly Reviews, and `~/infinite/principles/experiment-log.md`
   if present. All Notion access is read-only (search/fetch).
2. Answer, with evidence per item:
   - Where are we violating our own principles? (number + instance)
   - Where are we rationalizing instead of using evidence? (claims tagged
     [Assumption] being treated as [Data])
   - What are we avoiding? (overdue verdicts, unfilled outcomes, stale
     statuses — Principle 11)
   - What should we stop immediately?
   - What decision needs to be logged that hasn't been?
   - What should be converted into an experiment?
3. **Judgment-on-the-table check (Constitution, heaviest rule).** Count
   consecutive clean kills in the experiment log. If ≥3 with process holding,
   state plainly: the next thing to examine is the founder's judgment — the
   assumptions generating the bets — and recommend a written assumptions
   review.

## Output

Write a single markdown file at
`os/reports/<YYYY-MM-DD>-principle-check.md`:

```
# Principle Check — <YYYY-MM-DD>

## Recommended Notion Updates
For each row below, the human applies the property change in Notion.
- Ideas DB row "<name>": set Status = "Blocked by Principle Check"
  (reason: P# — <one line>)
- Ideas DB row "<name>": set Principle Check = "Needs Review"
- Decision Log row "<title>": set Status = "Under Review"  (or whatever)
- Experiments DB row "<name>": flag Needs Human  (reason)

(If nothing needs updating, write: "No status changes recommended.")

## What I Checked
- Constitution (P1–P13)
- Current Strategy: <pulled date>
- Decision Log: <N entries, last 30d>
- Ideas DB: <N changed>
- Experiments: <N active, N closed>
- Latest Weekly Review: <date>
- experiment-log.md: <N entries>

## Findings
For each finding:
- **Principle**: P#
- **Instance**: <one line, link the source row>
- **Evidence**: <quote / [Data]/[Estimate]/[Assumption] tag>
- **Severity**: P0 (active violation) | P1 (drift) | P2 (hygiene)
- **Fix**: <one concrete action>

## Judgment-on-the-table Check
Consecutive clean kills: <N>.
If ≥3: recommend written assumptions review. <plain statement>

## Summary
P0 count: <N>
P1 count: <N>
P2 count: <N>
Top fix: <one line>
```

- **Slack**: ping via
  `os/lib/slack_notify.sh "PRINCIPLE CHECK: P0=<N> P1=<N> — see os/reports/<file>"`.
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | principle-check | wrote <report path> | P0=<N> P1=<N>`.

## Hard rule

If you find nothing, say "no violations found" only after listing what you
checked. An empty audit with no evidence of looking is worse than no audit.
Never call any Notion write tool. The report and Slack are the only output
channels.

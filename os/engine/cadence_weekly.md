# cadence_weekly — Fri 17:00

Replaces `os/agents/weekly-review.md`. The Weekly Review is now a DRAFT
produced in local markdown. The human reads it and creates the Notion
Weekly Review row themselves. Read-only against Notion. No Notion writes.

## 0. Required reading

1. Read `principles/ai-operating-rules.md` and the engine contract in
   `os/engine/README.md`.
2. Capability probe: read `company_os_page` ID from
   `os/config/notion-ids.json`. On failure → Slack ping
   `weekly-review: Notion unreachable — run skipped`, append failure line
   to `os/logs/engine.log`, exit.

## 1. Snapshot

Run `os-sync` to refresh `os/mirrors/`. Pull in particular: last week's
Weekly Review (for "Next Week Priorities" = this week's plan), Current
Strategy, Decision Log entries this week, Ideas changed this week,
Experiments updated this week (+ verdicts from
`~/infinite/principles/experiment-log.md` if present), Marketing Library
updates, AI Activity Log for the week.

## 2. Skill output: weekly review draft (all 11 sections)

Execute the `weekly-review` skill at `os/skills/weekly-review/SKILL.md`
in read-only mode. It produces the full draft, not a Notion row. The
draft is the report. Every one of the 11 sections is present, including
the violations section — never skipped, never "N/A":

1. Planned priorities (from last week)
2. Actual work done
3. Wins
4. Misses — honest, with a named cause; do not soften
5. Decisions made (linked to mirror)
6. Experiments reviewed — verdicts quoted, bar vs result
7. **Principle violations** — count per principle by number, with
   instances. Zero only if a real check found zero.
8. **Shiny object check** — anything chased outside the current bet
   (Principle 2)?
9. Stop / Continue / Start
10. Next week's top 3 priorities (tied to the active hypothesis)
11. AI Chief of Staff notes — what we are avoiding, overcomplicating,
    ignoring; what to focus on. AI Score 1–10 + one-line justification.

## 3. Run filtered checks

Load `os/config/checks.yaml`. Filter to checks where `weekly` is in
`cadence`. For each, follow `os/engine/run_check.md`. The weekly set:

- All Needs-Attention checks (see midweek list).
- `bet_verdict_no_end_date` (Principle 11, medium)
- `bet_verdict_no_learning` (Principle 11, high)
- `posting_cadence_below_13` (Principle 11, medium — computed:
  `daily_log.posts_this_week >= 13` else fires)
- `noteworthy_moments_logged` (Principle 11, low — surface from Daily Log)
- `closed_bet_no_learning` (Principle 11, high)
- `weekly_review_draft_present` (Principle 10, high — meta-check: this
  draft must exist by end of run)

The violation counts produced by these checks are what populate section 7
of the draft.

## 4. Write the report

Write `os/reports/<YYYY-MM-DD>-weekly-review.md`:

```
# Weekly Review (DRAFT) — week of <YYYY-MM-DD>

> Status: DRAFT. The human reads this and creates the Notion Weekly
> Review row. The engine never sets the Notion status.

## 1. Planned priorities (from last week)
...
## 2. Actual work done
...
## 3. Wins
...
## 4. Misses
...
## 5. Decisions made
...
## 6. Experiments reviewed
...
## 7. Principle violations
- Principle 1: <count> — <instances>
- Principle 2: <count> — <instances>
... (all 13)
## 8. Shiny object check
...
## 9. Stop / Continue / Start
...
## 10. Next week's top 3 priorities
...
## 11. AI Chief of Staff notes + Score
...

---

## Standard weekly checks fired
- <fired rows from run_check.md, grouped by section>

## Clean checks
- <ids>
```

## 5. Digest fanout

- **Gmail (both founders)** if available: subject
  `Weekly Review — week of <date>`, body = review summary + open
  Needs-Human queue. If Gmail MCP unavailable headless → send the full
  digest to Slack and say "Gmail fallback" inline.
- **Slack short version** always: wins count, misses count, violations
  count, top priority for next week, path to the draft:
  ```
  Weekly review <date>: <wins>W / <misses>M / <violations>V. Top next: <line>. Draft: os/reports/<YYYY-MM-DD>-weekly-review.md
  ```

## 6. Run os-sync (commit + push the mirror)

Execute `os-sync` at the end of the run: export Notion → markdown mirrors
→ git commit `Company OS sync — <date>` → push (if remote + auth
available; otherwise note "push pending" in the report). This is the
version-history layer. It does not write to Notion.

## 7. Log + exit

Append to `os/logs/engine.log`:

```
[ISO ts] | weekly | run:complete | fired:<n> clean:<m> sync:<ok|pending>
```

NEVER write to Notion. The draft stays a draft until a human moves it
into Notion themselves.

---
name: os-bootstrap
description: >
  One-time (idempotent) creation of the Notion Company OS workspace: top page,
  10 areas, 5 databases with properties/templates/views, seeded Constitution,
  Strategy, and AI Operating Rules. Trigger on "bootstrap notion", "set up the
  company os workspace". Requires Notion MCP connected and authenticated.
---

# OS Bootstrap

> ⚠️ **EXCEPTION: This is the only skill in the system that writes to
> Notion.** It runs ONCE, with explicit human invocation, to create the
> workspace. After bootstrap, the AI is read-only against Notion forever —
> every other skill outputs markdown reports under `os/reports/` and the
> human applies them. **If you did not mean to bootstrap, exit now.** Do not
> run this skill to "fix" or "update" Notion content — that is the human's
> job from here on.

Creates the Notion workspace this OS runs on. Idempotent: before creating
anything, check `os/config/notion-ids.json` — if an ID exists and the object
is alive, verify/patch instead of recreating. Never create duplicates.

## Preflight

1. Notion MCP reachable (search for any page). If not: stop and print the
   setup command from SETUP.md.
2. Ask the human where to root the workspace (an existing page/teamspace), or
   create top-level page `Company OS`.

## Create (in order, recording every ID into `os/config/notion-ids.json`)

1. **Company OS** top page with a dashboard section (links added as objects
   are created) and an **AI Activity Log** child page (append-only — note:
   after bootstrap this page is no longer written to by the AI; ongoing
   audit goes to `os/logs/engine.log` instead).
2. **Company Constitution** page ← full content of
   `principles/company-constitution.md`.
3. **AI Operating Rules** page ← `principles/ai-operating-rules.md`.
4. **Current Strategy** page ← `strategy/current-strategy.md` (marked DRAFT —
   Needs Human).
5. **Decision Log** database — properties: Decision (title), Date, Area
   (Product/Marketing/Sales/Finance/Strategy/Hiring/Operations), Status
   (Proposed/Approved/Rejected/Reversed/Under Review), Decision Owner (person),
   Context, Options Considered, Chosen Option, Reason, Principles Used
   (multi-select P1–P13), Principle Conflicts, Evidence, Review Date, Outcome
   (Unknown/Worked/Failed/Mixed/Reversed), Learning. Template "New Decision"
   with the section skeleton. Views: All, Pending Review, Approved, Rejected,
   By Area, **Needs Human** (Status = Proposed OR Review Date past + Outcome
   Unknown).
6. **Ideas** database — properties: Idea (title), Type
   (Startup/Product/Marketing/Sales/Content/Partnership/Operations), Status
   (Raw/Evaluating/Validating/Approved/Parked/Killed/Blocked by Principle
   Check), Priority (P0–P3), Target Customer, Problem, Evidence, Estimated
   Effort (L/M/H), Revenue Potential (L/M/H/Unknown), Strategic Fit
   (Strong/Medium/Weak/Unknown), Principle Check (Passed/Failed/Needs Review),
   Principle Conflicts, AI Score (number), Next Action, Linked Experiment
   (relation), Linked Decision (relation). Template "New Idea". Views: All,
   Raw, Evaluating, Validating, Approved, Parked, Killed, By Type, By
   Priority, **Needs Human** (Status = Blocked by Principle Check OR Principle
   Check = Needs Review).
7. **Experiments** database — properties: Experiment (title), Status
   (Planned/Running/Completed/Stopped/Scaled/Inconclusive), Owner, Related
   Idea (relation), Hypothesis, Channel (Instagram/SEO/Landing
   Page/Marketplace/Cold Outreach/Referral/x.com/Other), Metric, Success Rule,
   Stop Rule, Budget (number), Start Date, End Date, Expected Result, Actual
   Result, Learning, Decision (Continue/Stop/Pivot/Scale/Inconclusive),
   Linked Decision (relation), **Engine Dir** (text — path under
   ~/infinite/principles/experiments/). Template "New Experiment". Views:
   Active, Planned, Completed, Stopped, By Channel, **Needs Human** (End Date
   past AND Decision empty).
8. **Marketing Library** database — properties per the source doc §11 +
   Principle Check. Seed entries: Positioning, Personas, Pain Points,
   Objections, Hooks, Ad Angles, Offers, Landing Copy, Competitor Notes,
   Learnings (empty shells). Views per §15.
9. **Weekly Reviews** database — properties per the source doc §12 (Week,
   dates, Status Draft/Reviewed/Closed, Main Focus, Wins, Misses, Principle
   Violations, Decisions Made (relation), Experiments Completed (relation),
   Top Learnings, Next Week Priorities, AI Score). Template "Weekly Review"
   with the 11-section skeleton. Views: Latest, Open, Closed.
10. **Meeting Notes** page, **Archive** page.
11. Dashboard: link the five **Needs Human** views prominently — this is the
    approval queue.

## Postflight

- Verify each recorded ID resolves; print a checklist of created objects.
- Append one line to `os/logs/engine.log`:
  `[ISO timestamp] | os-bootstrap | bootstrap completed | <N objects created>`.
- Tell the human: from this point on the AI is read-only against Notion;
  every other skill writes markdown reports under `os/reports/`. Run the
  Section-26 acceptance test next (`os/tests/acceptance.md`).

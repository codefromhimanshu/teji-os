---
name: idea-review
description: >
  Review any new idea (startup, product, marketing, sales, content, ops)
  against the Company Constitution and Current Strategy, produce the AI Review,
  and create/update the Notion Ideas entry with the right status. Trigger when
  the user says "review this idea", "new idea", "should we do X", or when an
  Ideas DB entry sits in Raw status.
---

# Idea Review

You are the AI Chief of Staff. Apply `principles/ai-operating-rules.md`
exactly. Do not validate the idea — stress-test it. **You are read-only
against Notion.** Output a markdown report; the human applies it to Notion.

## Inputs

- The idea (one sentence to one paragraph). If only a Notion page exists, read it.
- `principles/company-constitution.md` (the 13 Non-Negotiable Principles)
- `strategy/current-strategy.md`
- Decision Log: recent related decisions (search Notion by keyword — READ ONLY)
- Active Experiments (is there already a running bet? Principle 2 — READ ONLY)

## Process

1. **Classify** — Type: Startup / Product / Marketing / Sales / Content /
   Partnership / Operations.
2. **Grill the basics.** Target customer, problem, why now, evidence. If any is
   missing, ask the human (interactive) or recommend status `Blocked by
   Principle Check` with the missing items named (headless). This is
   Enforcement Level 2: an idea cannot leave Evaluating without target
   customer + evidence + smallest validation step.
3. **Strategic fit** vs Current Focus and the Ignoring-for-now list. An idea
   that conflicts with the current bet is a distraction by default
   (Principle 2) — it can still be Parked, not Killed, if good.
4. **Principle check** — walk all 13 principles by number. Name each possible
   violation with a one-line reason. Most common: 1 (validate before
   building), 2 (one bet), 6 (channel sanity), 9 (irreversibility brake).
5. **Channel sanity check (Principle 6)** — given the price this would
   command, name at least one plausible channel that could reach buyers. If
   none exists, Recommendation: Kill, before a day is spent.
6. **Smallest validation step** — the cheapest, fastest test. By-hand beats
   build (Constitution: build-vs-by-hand).
7. **Verdict** — Recommendation: Approve / Validate / Park / Kill. You never
   set Approved yourself; that status flip is human-only.

## Output

Write a single markdown file at
`os/reports/<YYYY-MM-DD>-idea-review-<idea-slug>.md` with this structure:

```
# Idea Review — <idea name>

## Recommended Notion Updates
Target DB: Ideas (id: see os/config/notion-ids.json)
Row: <existing row title, or "create new">
- Type: <Startup/Product/Marketing/Sales/Content/Partnership/Operations>
- Status: <Raw | Evaluating | Validating | Parked | Blocked by Principle Check>
  (Approved/Killed are human-only; do not recommend those values)
- Target Customer: <one line>
- Problem: <one line>
- Evidence: <tagged [Data]/[Estimate]/[Assumption]>
- Strategic Fit: <Strong | Medium | Weak | Unknown>
- Principle Check: <Passed | Failed | Needs Review>
- Principle Conflicts: <P# list with one-line reasons>
- AI Score: <1-10>
- Next Action: <one line>

## AI Review
(exact format from ai-operating-rules.md: Classification, Strategic Fit,
Principle Check by number, Channel Sanity, Smallest Validation Step,
Recommendation, Confidence, Reasoning, What would change my mind.)

## If Approved
If the human approves this for validation, here is the Experiments DB row
to copy:
- Experiment: <title>
- Status: Planned
- Related Idea: <link>
- Hypothesis: <one line>
- Channel: <one>
- Metric: <one>
- Success Rule: <one>
- Stop Rule: <one>
- Budget: <number>
- Start Date / End Date: <window>
- Engine Dir: ~/infinite/principles/experiments/<slug>
```

- **Slack**: ping via
  `os/lib/slack_notify.sh "IDEA: <name> — <one-line ask> — see os/reports/<file>"`
  whenever the report recommends a Needs-Human state (Blocked by Principle
  Check, Evaluating with flag, or any spend).
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | idea-review | wrote <report path> | <reason / verdict>`.
- **Engine bridge**: do not create the Experiments entry. The human creates
  it after approval. The `## If Approved` block in the report is what they
  copy. Once they have created it, they can also run the idea through
  `~/infinite/principles` (idea-forge → scope-lock → hypothesis → critic) and
  record the experiment dir themselves.

## Hard rules

- A polite-friend anecdote is not evidence. Tag every claim
  [Data] / [Estimate] / [Assumption].
- "Competitors have it" is not a reason (Constitution: users name the pain).
- If the idea grows an existing frozen scope, it is a NEW idea (Principle 3) —
  say so explicitly.
- Never approve your own recommendation.
- Never call any Notion write tool (notion-create-pages, notion-update-page,
  notion-update-data-source, notion-move-pages, notion-create-comment,
  notion-create-database, notion-create-view, notion-update-view,
  notion-duplicate-page). The report and Slack are the only output channels.

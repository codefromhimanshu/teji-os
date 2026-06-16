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
exactly. Do not validate the idea — stress-test it.

## Inputs

- The idea (one sentence to one paragraph). If only a Notion page exists, read it.
- `principles/company-constitution.md` (the 13 Non-Negotiable Principles)
- `strategy/current-strategy.md`
- Decision Log: recent related decisions (search Notion by keyword)
- Active Experiments (is there already a running bet? Principle 2)

## Process

1. **Classify** — Type: Startup / Product / Marketing / Sales / Content /
   Partnership / Operations.
2. **Grill the basics.** Target customer, problem, why now, evidence. If any is
   missing, ask the human (interactive) or set status `Blocked by Principle
   Check` with the missing items named (headless). This is Enforcement Level 2:
   an idea cannot leave Evaluating without target customer + evidence +
   smallest validation step.
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

Produce the AI Review in the exact format from `ai-operating-rules.md`, then:

- **Notion**: create or update the Ideas DB entry (use IDs from
  `os/config/notion-ids.json`): fill Type, Status, Target Customer, Problem,
  Evidence, Strategic Fit, Principle Check, Principle Conflicts, AI Score
  (1-10), Next Action. Status rules:
  - missing basics → `Blocked by Principle Check`
  - reviewed, needs human call → `Evaluating` + flag in Next Action
  - recommendation Park/Kill → leave current status, set Next Action to the
    recommendation; a human moves it
- **Slack**: if any Needs-Human state was set, ping via
  `os/lib/slack_notify.sh "IDEA: <name> — <one-line ask>"`.
- **Audit**: append one line to the Notion AI Activity Log.
- **Engine bridge**: if the human later approves for validation, create the
  Experiments DB entry and instruct: run the idea through
  `~/infinite/principles` engine (idea-forge → scope-lock → hypothesis →
  critic), recording the experiment dir in the `Engine Dir` property.

## Hard rules

- A polite-friend anecdote is not evidence. Tag every claim
  [Data] / [Estimate] / [Assumption].
- "Competitors have it" is not a reason (Constitution: users name the pain).
- If the idea grows an existing frozen scope, it is a NEW idea (Principle 3) —
  say so explicitly.
- Never approve your own recommendation.

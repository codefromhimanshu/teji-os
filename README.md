# Infinite Company OS

AI-managed operating system for a two-person startup.

```
Notion  = the company's working brain (source of truth)
Claude  = chief of staff: reviews, enforces principles, drafts, never self-approves
GitHub  = version history of how the company's thinking evolved
Slack   = real-time pings when a human is needed
Gmail   = weekly digests
```

The Constitution (`principles/company-constitution.md`) is the Foundation
document: one bet at a time, frozen scope, pre-registered bars, ambiguous is a
kill, founder final call, the irreversibility brake. The OS exists to enforce
it — including on the founders.

## How it runs

- **On demand** (Claude Code session in this repo): `idea-review`,
  `decision-log`, `marketing-review`, `principle-check`, `daily-focus`,
  `weekly-review`, `os-sync`, `os-bootstrap` — see `os/skills/`.
- **On schedule** (Claude Code cron, see `os/config/cadences.md`):
  weekday focus briefing, Tue/Thu chase of overdue verdicts and decision
  reviews, Friday weekly review + digest + git sync, monthly audit, quarterly
  principles audit (including the judgment-on-the-table rule).
- **Human in the loop**: anything needing a decision lands in the Notion
  **Needs Human** views (the approval queue) + a Slack ping. Humans flip
  statuses; the AI never sets Approved/Scaled and never edits the Constitution
  or Strategy.

## The loop

```
Idea captured → AI review vs principles → classify (validate/park/kill/approve)
→ human decides → experiment via ~/infinite/principles engine (forge → scope-lock
→ hypothesis → critic → launch) → verdict vs pre-registered bar → weekly review
counts violations → monthly/quarterly audits → company memory updated (Notion + git)
```

## Layout

```
principles/   constitution + AI operating rules (canonical seeds; mirrors)
strategy/     current strategy (mirror)
decisions/ ideas/ experiments/ marketing/ reviews/ archive/   notion mirrors
os/skills/    the 8 skills
os/agents/    scheduled-agent prompts
os/config/    notion IDs, cadences, env example
os/lib/       slack_notify.sh
os/tests/     acceptance tests
docs/         design spec
```

## Setup

See `SETUP.md`. Acceptance: `os/tests/acceptance.md`.

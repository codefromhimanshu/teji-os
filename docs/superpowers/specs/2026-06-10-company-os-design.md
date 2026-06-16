# Infinite Company OS — Design Spec

Date: 2026-06-10
Status: Approved (user directed full build)
Repo: `~/infinite/company-os`

## 1. Purpose

An AI-managed company operating system for a two-person startup. Notion is the
company's working brain, Claude Code is the chief-of-staff layer, GitHub is the
version-history layer, Slack and Gmail are the notification layers. The system
runs on schedules without depending on a human to trigger it, and it calls for
human intervention through an explicit approval queue.

The system enforces the founders' Foundation document (constitution): one bet
at a time, frozen scope, pre-registered success bars, kill rules ("ambiguous is
a kill"), discipline over motivation, founder final call with written cases,
and the irreversibility brake.

## 2. Architecture

```
Notion "Company OS"     = source of truth (10 areas, 5 databases)
Claude Code             = chief of staff (on-demand skills + scheduled agents)
~/infinite/company-os   = git repo: OS code + markdown backup mirror
Slack #company-os       = real-time pings (incoming webhook, plain HTTP)
Gmail                   = digests (Gmail MCP via claude.ai)
GitHub `company-os`     = remote for version history
~/infinite/principles   = existing experiment engine (unchanged; the OS links to it)
```

Decisions made with the user:
1. **Notion-centric**: Notion databases are canonical; git holds weekly markdown exports.
2. **Scheduled Claude agents** (Claude Code cron) run the loops unattended.
3. **Full fanout** notifications: Notion Needs-Human queue + Slack pings + Gmail digests.
4. **Full doc implementation**: all 10 Notion areas, all views, all 5 enforcement
   levels, daily/weekly/monthly/quarterly agents.
5. Constitution and AI Operating Rules are **seeded from the Foundation document**,
   not the generic template.

## 3. Notion workspace

Top page `Company OS` containing:

1. **Company Constitution** — seeded from Foundation doc: how we work together
   (direction is founder's, written-case-then-decide, no relitigating, trust
   through mistakes, the irreversibility exception, what the founder can be held
   to, judgment-on-the-table rule), the engine (one bet at a time, channel
   sanity check, frozen scope, V1 = hypothesis → build → build-vs-hand, fixed
   window + pre-registered bar, hand-gotten first users, verdict rules,
   reach-vs-product failure separation), fixed layer vs operating rules layer,
   hiring rule (3-part test), fundraising rule.
2. **Current Strategy** — Current Focus, Primary Customer, Main Goal, Revenue
   Hypothesis, Channels, Active Experiments, Ignoring-for-now, Review Date.
   Initial content drafted from `principles/` repo state; marked Needs Human to fill.
3. **Decision Log** (DB) — properties per source doc §8 + template "New Decision".
4. **Ideas** (DB) — properties per source doc §9 + template "New Idea" + status
   `Blocked by Principle Check`.
5. **Experiments** (DB) — properties per source doc §10 + template "New
   Experiment" + property `Engine Dir` (path/link to `~/infinite/principles/experiments/<id>`).
6. **Marketing Library** (DB) — properties per source doc §11 + marketing rules page.
7. **Weekly Reviews** (DB) — properties per source doc §12 + template.
8. **AI Operating Rules** — permission model (below), review format, enforcement levels.
9. **Meeting Notes** — simple page list.
10. **Archive** — parking ground; nothing deleted.

Views: all views listed in source doc §15 step 4, plus a **"Needs Human" view
per database** (filter: status in {Blocked by Principle Check, Needs Human
Decision, Proposed, Draft-ready-for-review}) and a dashboard page that links
the five queues.

Notion is bootstrapped by an idempotent skill (`os-bootstrap`) run through the
Notion MCP. It records created page/database IDs into `os/config/notion-ids.json`
so all later agents address objects by ID, never by search.

## 4. Repo layout

```
company-os/
  README.md                  # what this is, how to operate it
  SETUP.md                   # the 4 manual steps (Notion OAuth, Slack webhook,
                             #   Gmail auth, GitHub remote) + verification prompts
  docs/superpowers/specs/    # this spec
  os/
    skills/                  # Claude Code skills (wired via .claude/skills)
      os-bootstrap/          # one-time Notion workspace creation (idempotent)
      idea-review/           # AI Review format vs Constitution+Strategy
      decision-log/          # capture decision w/ principles used/conflicted
      marketing-review/      # marketing rules check
      principle-check/       # ad-hoc drift audit ("act as strict chief of staff")
      weekly-review/         # Friday draft + violations + digest + sync
      daily-focus/           # morning priorities + distraction flags
      os-sync/               # Notion -> markdown export -> git commit -> push
    agents/                  # prompt files used by cron jobs (thin wrappers
                             #   that invoke the matching skill headlessly)
    config/
      notion-ids.json        # created object IDs (committed; not secret)
      os.env.example         # SLACK_WEBHOOK_URL=...   (real os.env gitignored)
      cadences.md            # cron expressions + what runs when
    lib/
      slack_notify.sh        # curl wrapper; $SLACK_WEBHOOK_URL; safe no-op + log if unset
  principles/ strategy/ decisions/ ideas/
  experiments/ marketing/ reviews/ archive/    # markdown mirror written by os-sync
```

`.claude/skills/` in the repo points at `os/skills/` so the skills are
available whenever Claude Code runs in `~/infinite/company-os`.

## 5. Scheduled agents (Claude Code cron)

| Agent | Cadence | Behavior |
|---|---|---|
| daily-focus | Mon–Fri 09:00 | Read Constitution, Strategy, active Experiments, open Ideas → 3 priorities, avoid-list, likely-violated principle → Slack |
| midweek-check | Tue+Thu 14:00 | Experiments past window without verdict; decisions past Review Date; ideas stuck >7d in Evaluating → Slack ping + Needs Human statuses |
| weekly-review | Fri 17:00 | Draft Weekly Review in Notion (planned vs done, wins, misses, violations count per principle, shiny-object check, stop/continue/start, next-week priorities), Gmail digest to both founders, then run os-sync (export → commit → push) |
| monthly-audit | 1st 10:00 | Constitution/Strategy staleness, killed-idea patterns, failed-experiment patterns → draft findings page, Needs Human |
| quarterly-audit | Jan/Apr/Jul/Oct 1st | "Are principles real or theoretical"; **judgment-on-the-table rule**: if ≥N consecutive clean kills, flag that founder judgment itself goes on the table |

Headless risk and mitigation: interactively-authenticated MCPs (Notion OAuth,
Gmail) may be unavailable in headless runs. Each agent run starts with a
capability probe; on Notion failure it reports the failure to Slack (webhook is
plain HTTP and always available) instead of failing silently. Gmail digest
failure falls back to Slack digest. Setup includes an explicit headless
verification step per agent before its cron is registered.

## 6. Enforcement levels

1. **Reminder** — every AI review names violated principles inline (AI Review format).
2. **Required justification** — idea cannot move past Evaluating unless evidence,
   target customer, and smallest validation step are filled; AI asks the three
   questions and blocks otherwise.
3. **Status block** — AI sets `Blocked by Principle Check`; only humans unblock.
4. **Weekly violation report** — violations counted per principle in every Weekly Review.
5. **Decision review** — midweek agent chases decisions past Review Date until Outcome filled.

## 7. Permission model

AI may without approval: create drafts, summaries, templates, weekly review
drafts, classify Raw/Evaluating/Needs Review, set Blocked statuses, update AI
Notes, append to logs.

AI requires human approval (status flip in Notion by a human): Approved ideas,
Scaled experiments, Constitution/Strategy changes, archiving decisions,
spending money, final business decisions.

AI never: deletes core pages, hides failed experiments, rewrites history
silently, approves its own recommendations, treats assumptions as evidence.

Irreversible-decision class (long contracts, equity/control, legal exposure,
reputation-damaging publishing, unrecoverable data, burning relationships)
**always** routes to Needs Human regardless of principle-check outcome.

Every AI write appends one line to an `AI Activity Log` page in Notion
(timestamp, object, action, reason) — the audit trail.

## 8. Human-in-the-loop flow

```
AI flags item → Notion status Needs Human / Blocked by Principle Check
            → Slack ping (instant, via webhook)
            → Gmail Friday digest (catch-all)
Human flips status in Notion → next agent run proceeds accordingly
```

## 9. Experiment engine bridge

The `~/infinite/principles` engine remains the execution layer. When an idea is
Approved for validation, `idea-review` (or the human) creates an Experiments DB
entry whose `Engine Dir` names the experiment directory; the engine's
`verdict` output is mirrored back into the Notion experiment (Actual Result,
Learning, Decision) by `os-sync`/`weekly-review`.

## 10. Testing / acceptance

1. **Section-26 test**: idea "Build a full mobile app before more validation" →
   review must return `Principle Check: Failed`, cite "validate before
   building", recommend a validation experiment, and set Blocked status.
2. Headless probe test per scheduled agent before cron registration.
3. End-to-end: one real idea → capture → review → block → human approve →
   experiment entry → appears in weekly review draft.
4. os-sync produces markdown mirror + git commit; re-run is idempotent.
5. Acceptance checklist of source doc §25 all pass.

## 11. Manual setup steps (user-performed, prompted by SETUP.md)

Current state found on this machine (2026-06-10): Notion MCP not configured;
`gh` tokens invalid for both accounts; Gmail available via claude.ai connector
after authentication; no Slack webhook.

1. `claude mcp add --transport http notion https://mcp.notion.com/mcp` + `/mcp` OAuth.
2. Create Slack incoming webhook for #company-os; put URL in `os/config/os.env`.
3. Gmail MCP authenticate (claude.ai connector).
4. `gh auth login`, then `gh repo create company-os --private` + push.

## 12. Build order

1. Repo scaffolding + this spec + README/SETUP committed.
2. Skills: idea-review, decision-log, marketing-review, principle-check,
   daily-focus, weekly-review, os-sync, os-bootstrap.
3. Slack lib + config plumbing.
4. Notion bootstrap run (after user OAuth) → notion-ids.json.
5. Scheduled agents: headless verify each, then register crons.
6. Acceptance tests (§10), including Section-26 test.

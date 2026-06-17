---
name: os-sync
description: >
  Snapshot the Notion Company OS to local markdown mirrors in this repo,
  commit, and push to GitHub — the read-snapshot step the engine runs before
  each cadence check. Trigger on "sync", "snapshot notion", "export to git",
  or as the first step of any cadence (daily/midweek/weekly/monthly/quarterly).
---

# OS Sync (Notion → local mirrors → GitHub)

**This skill READS Notion only. It never writes to Notion. The mirrors are a
local snapshot for the check engine to query without hammering the API.**

GitHub is the versioned archive of those snapshots; Notion stays the working
interface (humans only). This skill is idempotent — re-running with no
Notion changes produces no commit.

## Export map

Snapshots live under `os/mirrors/<kind>/`. The Constitution, AI Operating
Rules, and Current Strategy are git-tracked authoritative copies at their
canonical paths — not mirrors — so they stay where they are.

| Notion object | File |
|---|---|
| Company Constitution page | `principles/company-constitution.md` (canonical, not a mirror) |
| AI Operating Rules page | `principles/ai-operating-rules.md` (canonical, not a mirror) |
| Current Strategy page | `strategy/current-strategy.md` (canonical, not a mirror) |
| Each Decision Log entry | `os/mirrors/decisions/YYYY-MM-DD-<slug>.md` |
| Ideas DB (table snapshot) | `os/mirrors/ideas/ideas-snapshot.md` |
| Each Experiment entry | `os/mirrors/experiments/<slug>.md` |
| Marketing Library (snapshot) | `os/mirrors/marketing/library-snapshot.md` |
| Each Weekly Review | `os/mirrors/reviews/YYYY-MM-DD-weekly-review.md` |
| Archived items | `os/mirrors/archive/` |

## Process

1. Probe Notion read access; failure → Slack-report, append one line to
   `os/logs/engine.log`, and exit.
2. Read each object by ID (`os/config/notion-ids.json`); render to markdown.
   Preserve full text of decisions and reviews; snapshots for the big DBs.
   **Read-only Notion MCP calls only** — no `notion-create-*`,
   `notion-update-*`, `notion-move-pages`, or `notion-duplicate-page`.
3. Constitution/Strategy diff guard: if the Notion page differs from the
   committed canonical file AND no Decision Log entry this week mentions a
   constitution/strategy change → flag it as a Principle 8 violation. Action:
   Slack ping + line in today's report
   (`os/reports/<YYYY-MM-DD>-os-sync.md`) noting
   "constitution changed without a logged decision". Still snapshot the
   change; never hide it. Note it in the commit message. The engine does
   not write anything back to Notion — the human resolves it there.
4. `git add` the mirror dirs (and the canonical files if they were updated
   by a human-driven sync); commit:
   `Company OS sync — YYYY-MM-DD` (+ one line per notable change).
5. Push to origin if a remote is configured and credentials work; otherwise
   note "local commit only — push pending gh auth" in the Slack message.
6. Append one line to `os/logs/engine.log`:
   `[ISO timestamp] | os-sync | snapshot | <counts or "no-op">`.

## Hard rules

- Never write to Notion. Read-only MCP calls only.
- Never force-push. Never rewrite mirror history.
- Never delete a mirror file because a Notion page disappeared — move it to
  `os/mirrors/archive/` with a dated note instead (nothing is hidden, ever).

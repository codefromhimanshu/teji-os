---
name: os-sync
description: >
  Export the Notion Company OS to markdown mirrors in this repo, commit, and
  push to GitHub — the version-history layer. Trigger on "sync", "backup
  notion", "export to git", or as the final step of weekly-review.
---

# OS Sync (Notion → git → GitHub)

GitHub is the versioned archive; Notion stays the working interface. This
skill is idempotent — re-running with no Notion changes produces no commit.

## Export map

| Notion object | File |
|---|---|
| Company Constitution page | `principles/company-constitution.md` |
| AI Operating Rules page | `principles/ai-operating-rules.md` |
| Current Strategy page | `strategy/current-strategy.md` |
| Each Decision Log entry | `decisions/YYYY-MM-DD-<slug>.md` |
| Ideas DB (table snapshot) | `ideas/ideas-snapshot.md` |
| Each Experiment entry | `experiments/<slug>.md` (links Engine Dir) |
| Marketing Library (snapshot) | `marketing/library-snapshot.md` |
| Each Weekly Review | `reviews/YYYY-MM-DD-weekly-review.md` |
| Archived items | `archive/` |

## Process

1. Probe Notion access; failure → Slack-report and exit.
2. Read each object by ID (`os/config/notion-ids.json`); render to markdown.
   Preserve full text of decisions and reviews; snapshots for the big DBs.
3. Constitution/Strategy diff guard: if the Notion page differs from the
   committed file AND no Decision Log entry this week mentions a
   constitution/strategy change → flag it ("constitution changed without a
   logged decision" — Principle 8 violation, Slack ping). Still export; never
   hide the change. Note it in the commit message.
4. `git add` the mirror dirs only; commit:
   `Company OS sync — YYYY-MM-DD` (+ one line per notable change).
5. Push to origin if a remote is configured and credentials work; otherwise
   note "local commit only — push pending gh auth" in the Slack message.
6. Append to AI Activity Log.

## Hard rules

- Never force-push. Never rewrite mirror history.
- Never delete a mirror file because a Notion page disappeared — move it to
  `archive/` with a dated note instead (nothing is hidden, ever).

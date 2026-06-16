# Scheduled agent cadences

Registered as Claude Code cron jobs (see SETUP.md step 5). Each job runs the
matching prompt file in `os/agents/` with working directory
`~/infinite/company-os`.

| Job | Cron | Prompt |
|---|---|---|
| daily-focus | `0 9 * * 1-5` | os/agents/daily-focus.md |
| midweek-check | `0 14 * * 2,4` | os/agents/midweek-check.md |
| weekly-review | `0 17 * * 5` | os/agents/weekly-review.md |
| monthly-audit | `0 10 1 * *` | os/agents/monthly-audit.md |
| quarterly-audit | `0 10 1 1,4,7,10 *` | os/agents/quarterly-audit.md |

Rules:
- Do not register a job until its prompt has passed one headless verification
  run (SETUP.md step 6).
- Every agent starts with the Notion capability probe and reports failures via
  Slack webhook (or `os/logs/agent-failures.log` when Slack is unset). No
  silent failures.

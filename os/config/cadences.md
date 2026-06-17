# Scheduled cadences

Registered as Claude Code cron jobs (see SETUP.md). Each job runs the matching
engine runbook with working directory `~/infinite/company-os`. The engine is
read-only against Notion; all outputs land in `os/reports/`, `os/logs/engine.log`,
and Slack.

| Job              | Cron                  | Runbook                              |
|------------------|-----------------------|--------------------------------------|
| daily-focus      | `0 9 * * 1-5`         | `os/engine/cadence_daily.md`         |
| midweek-check    | `0 14 * * 2,4`        | `os/engine/cadence_midweek.md`       |
| weekly-review    | `0 17 * * 5`          | `os/engine/cadence_weekly.md`        |
| monthly-audit    | `0 10 1 * *`          | `os/engine/cadence_monthly.md`       |
| quarterly-audit  | `0 10 1 1,4,7,10 *`   | `os/engine/cadence_quarterly.md`     |

Each runbook follows the canonical procedure in `os/engine/run_check.md` and
draws its checklist from `os/config/checks.yaml`.

Rules:
- Do not register a job until its runbook has passed one headless verification
  run (SETUP.md).
- Every cadence starts with the Notion capability probe; failures go to Slack
  (or `os/logs/engine.log` when Slack is unset). No silent failures.
- No cadence writes to Notion. Ever. The human reads the report and updates
  Notion themselves.

The previous `os/agents/*.md` prompts have been moved to `os/agents.deprecated/`
for git history; they are no longer wired into any cron job.

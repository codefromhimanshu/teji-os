# Setup

Six steps. 1–4 need you (auth/credentials); 5–6 Claude does with you watching.

## 1. Notion MCP (required first)

```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

Then in a Claude Code session: `/mcp` → authenticate Notion → approve access
to the workspace where Company OS should live.

Verify: ask Claude — "Search my Notion workspace and list pages you can
access. Do not modify anything."

## 2. Slack webhook

1. https://api.slack.com/apps → Create New App → From scratch → name
   "Company OS", pick your workspace.
2. Incoming Webhooks → activate → Add New Webhook → channel `#company-os`
   (create the channel first).
3. `cp os/config/os.env.example os/config/os.env` and paste the URL into
   `SLACK_WEBHOOK_URL`. Fill `FOUNDER_EMAIL_2`.

Verify: `os/lib/slack_notify.sh "Company OS online"` → message appears.

## 3. Gmail (claude.ai connector)

In a Claude Code session: authenticate the Gmail connector when prompted
(`/mcp` → Gmail). Used for the Friday digest; falls back to Slack when
unavailable headless.

## 4. GitHub

```bash
gh auth login -h github.com        # tokens were invalid on 2026-06-10
gh repo create company-os --private --source . --push
```

## 5. Bootstrap Notion

In a Claude Code session in this repo:

```
Run the os-bootstrap skill.
```

Creates the Company OS workspace (10 areas, 5 databases, templates, views,
seeded Constitution/Strategy/Operating Rules) and fills
`os/config/notion-ids.json`. Idempotent — safe to re-run.

## 6. Register the scheduled agents

For each agent in `os/config/cadences.md`:

1. Headless verification: `claude -p "$(cat os/agents/<name>.md)"` from the
   repo root — must end in real output or a clean Slack-reported failure.
2. Ask Claude: "Register the <name> cron job per os/config/cadences.md."

## Done when

`os/tests/acceptance.md` T1–T6 all pass — T1 is the Section-26 test: the
mobile-app-before-validation idea must come back `Principle Check: Failed`.

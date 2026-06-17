# run_check — canonical procedure for executing a single check

This is the per-check inner loop used by every cadence runbook
(`cadence_daily.md`, `cadence_midweek.md`, `cadence_weekly.md`,
`cadence_monthly.md`, `cadence_quarterly.md`). It is read-only against
Notion. Follow it exactly.

## Preconditions (the cadence runbook handles these once per run)

1. `principles/ai-operating-rules.md` has been read.
2. `os/engine/README.md` (the engine contract) has been read.
3. Capability probe passed: `company_os_page` ID from
   `os/config/notion-ids.json` fetched successfully. On failure the
   cadence runbook already Slack-pinged, logged, and exited; we are not
   here.
4. `os-sync` skill has produced a fresh `os/mirrors/` snapshot for the run.
5. `os/config/checks.yaml` has been loaded and filtered to the checks
   whose `cadence` list contains the current cadence.

## Per-check loop

For each filtered check:

1. **Identify the source.**
   - `source.type: notion_view` → fetch by `source.view_block_id` from
     `os/config/notion-ids.json` (or directly off the Reflection / Needs
     Attention page if the view block ID is `TODO`). Read-only fetch.
   - `source.type: computed_rule` → evaluate `rule:` against the
     `os/mirrors/` snapshot. Computed rules never touch Notion live.

2. **Evaluate.** A check fires when the query returns ≥1 row, or the
   computed rule's predicate is true. Note: empty result = clean. Do not
   guess; if the view block ID is `TODO` and the view cannot be resolved,
   flag the check itself as "could not evaluate" in the report and add a
   log line `view_unresolved`.

3. **For each row that fires:**
   - Add one bullet under the right section in today's report file. Format:
     ```
     - **<title>** — <message>. (Principle <n>, severity <high|medium|low>)
       Row: <name or page link>
       Action: <action>
     ```
   - Queue a Slack ping fragment: `<title>: <count>` (consolidated at the
     end of the run, never per-check).
   - Append a line to `os/logs/engine.log`:
     `[ISO ts] | <cadence> | check:<id> | fired:<row-count>`.

4. **If the check is clean:**
   - No row in the report (or, in `cadence_weekly.md`'s closing summary,
     a check-mark line in the "Clean checks" footer — keeps the audit
     trail intact).
   - Append `[ISO ts] | <cadence> | check:<id> | clean` to engine.log.

5. **Severity → enforcement level (apply rules from ai-operating-rules.md):**
   - `high` violations (principle violations, data-loss risk,
     irreversibility) → flag the row as `NEEDS HUMAN` in the report and
     include in the Slack consolidated ping.
   - `medium` hygiene issues → flag inline in the report; Slack ping
     mentions the count, not each row.
   - `low` nice-to-haves → report only, no Slack.

## End-of-run consolidation (the cadence runbook does this once)

1. If any check fired: write the report, then send ONE Slack message via
   `os/lib/slack_notify.sh` with:
   - one-line headline (cadence + total fired + top section),
   - section counts,
   - path to the report.
2. If no check fired and no skill output flagged drift: write an
   "all green" report (still write it — the audit trail matters), then
   send ONE Slack OK line.
3. Append `[ISO ts] | <cadence> | run:complete | fired:<n> clean:<m>` to
   `os/logs/engine.log`.

## Hard rules

- NEVER call `notion-create-*`, `notion-update-*`, `notion-move-*`,
  `notion-duplicate-*`, `notion-create-comment`, `notion-create-view`,
  `notion-update-view`. The engine has read tools only.
- NEVER skip the log line. A check with no log line did not happen.
- NEVER fabricate a view ID. If `view_block_id: TODO` in
  `os/config/checks.yaml`, treat the check as unresolved and surface that
  fact in the report so a human can fill in the ID.
- NEVER soften severity. A `high` check stays `high`.
- NEVER batch a Slack ping with anything outside the current run.

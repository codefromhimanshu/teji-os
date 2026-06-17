---
name: decision-log
description: >
  Record a company decision in the Notion Decision Log with context, options,
  reasoning, principles used/conflicted, evidence, and a review date. Trigger
  on "log this decision", "we decided", "make the call on", or when an idea
  review ends in a human Approve/Kill that is not yet logged.
---

# Decision Log

Every important decision gets recorded so debates are not repeated and the
company remembers why. Apply `principles/ai-operating-rules.md`. **You are
read-only against Notion.** Output a markdown report; the human copies it
into the Notion Decision Log.

## Process

1. **Gather** (ask if missing — do not invent): the decision in one sentence;
   context (what forced it now); options considered (≥2 — if only one option
   was ever on the table, say so honestly); chosen option; reason; evidence
   ([Data]/[Estimate]/[Assumption] tagged); owner.
2. **Written-case check (Principle 8).** For big decisions: was the partner's
   written case made and read? If not, note "no written case" in the entry —
   visible, not blocking. The Constitution requires the case for big calls.
3. **Principle mapping.** Principles Used (by number) and Principle Conflicts.
   Any conflict with 1-13 → flag in the entry AND Slack ping.
4. **Irreversibility class (Principle 9).** Contracts/lock-in, equity/control,
   legal, reputation, data loss, burned channels → recommend Status
   `Proposed` + Needs Human, never auto-recorded as Approved. Note
   reversibility: Cheap / Costly / Effectively permanent.
5. **Review date.** Every decision gets one (default: 30 days, or the linked
   experiment's window end). The midweek agent chases overdue reviews until
   Outcome + Learning are filled (Enforcement Level 5).

## Output

Write a single markdown file at
`os/reports/<YYYY-MM-DD>-decision-<slug>.md` with this structure:

```
# Decision — <one-sentence decision>

## Recommended Notion Updates
Target DB: Decision Log (id: see os/config/notion-ids.json)
Row: create new
- Decision: <title>
- Date: <YYYY-MM-DD>
- Area: <Product | Marketing | Sales | Finance | Strategy | Hiring | Operations>
- Status: Proposed   (Approved is human-only)
- Decision Owner: <person>
- Review Date: <YYYY-MM-DD>
- Outcome: Unknown
- Linked Ideas / Experiments: <relations to add by hand>

## Decision Record (copy body into the Notion page)

### Context
<what forced this now>

### Options Considered
1. <option A>
2. <option B>
(If only one was on the table, say so honestly.)

### Chosen Option
<option>

### Reason
<why>

### Principles Used
P# — <one line>
P# — <one line>

### Principle Conflicts
P# — <one line>  (or "none")

### Evidence
- [Data] ...
- [Estimate] ...
- [Assumption] ...

### Irreversibility
<Cheap | Costly | Effectively permanent> — <one line>

### Written Case
<present | "no written case">  (Principle 8)

### Review Date
<YYYY-MM-DD> — what we will check then.
```

- **Slack**: if Status = Proposed or any Principle Conflict exists, ping via
  `os/lib/slack_notify.sh "DECISION: <title> — needs human approve/reject —
  see os/reports/<file>"`.
- **Audit**: append one line to `os/logs/engine.log`:
  `[ISO timestamp] | decision-log | wrote <report path> | <one-line reason>`.

## Hard rules

- Status `Approved` is set by humans only. The report never recommends
  Approved.
- Never edit a past decision's substance; corrections are new entries that
  supersede (note "Superseded by" both ways in the new report). History is
  the asset.
- A decision without a review date is not logged — ask for one.
- Never call any Notion write tool. The report and Slack are the only output
  channels.

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
company remembers why. Apply `principles/ai-operating-rules.md`.

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
   legal, reputation, data loss, burned channels → Status `Proposed` + Needs
   Human, never auto-recorded as Approved. Note reversibility: Cheap / Costly /
   Effectively permanent.
5. **Review date.** Every decision gets one (default: 30 days, or the linked
   experiment's window end). The midweek agent chases overdue reviews until
   Outcome + Learning are filled (Enforcement Level 5).

## Output

- Notion Decision Log entry (IDs from `os/config/notion-ids.json`):
  Decision, Date, Area, Status (Proposed unless a human already approved),
  Owner, Context, Options Considered, Chosen Option, Reason, Principles Used,
  Principle Conflicts, Evidence, Review Date, Outcome (Unknown).
- Link related Ideas/Experiments entries.
- Slack ping if Status = Proposed (a human must approve).
- Append to AI Activity Log.

## Hard rules

- Status `Approved` is set by humans only.
- Never edit a past decision's substance; corrections are new entries that
  supersede (note "Superseded by" both ways). History is the asset.
- A decision without a review date is not logged — ask for one.

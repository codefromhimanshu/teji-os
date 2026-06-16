---
title: Streak — Build-in-Public Publishing Tool
working_name: Streak (provisional)
type: Product (first product)
status: Evaluating
created: 2026-06-16
source: idea-review session, AI Chief of Staff
notion_target: Ideas DB (to be created when Notion MCP authenticated)
---

# Idea: Streak — Build-in-Public Publishing Tool

## One-line

A small tool for the two founders that takes raw inputs from our day (commits,
decisions, learnings, what we built) and drafts 2–3 tweet-length posts; we pick
and publish 1, daily. Built to reduce the felt friction at the moment of
publishing on x.com — the "cringe / not sharp enough / busy / don't want to"
wall — so we sustain a daily build-in-public cadence and the work we ship turns
into credibility.

## Target Customer

- **V0 (now):** us, the two founders.
- **Eventually:** solo builders and indie hackers trying to maintain a public-writing cadence, reached via x.com + indie hacker communities + the build-log posts the tool itself generates (eat-your-own-dog-food distribution).

## Problem (named precisely)

Publishing friction at the moment of hitting send — *not* ideation. The wall is:

- Emotional / social — *"feels cringe, not sharp enough"*
- Situational — *"busy, no time to compose"*
- Motivational — *"don't want to"*

Existing tools (schedulers, generic AI tweet generators) optimize the wrong bottleneck. They reduce the cost of *creating* a post; they don't reduce the cost of *hitting publish*.

## Hypothesis

A tool that drafts artifact-anchored 2–3 post options from our actual day's raw inputs will let us sustain ≥ 5 posting days out of 7, each week, for 4 consecutive weeks, across both founder accounts.

## Pre-registered bar (Principle 4 — does not move)

**Served-user side (testable now):**
- Both founders post ≥ 5 days/week via the tool, for 4 consecutive weeks.
- Miss any week → kill or restart hypothesis.

**Stranger side (activates at week 4 verdict):**
- By end of week 8, ≥ 3 inbound DMs / replies / follows from strangers in our field across both accounts.
- Likes from existing friends and existing network do not count.

## Evidence

- [Assumption] that a drafting tool moves the *publishing-moment* friction, not just the ideation friction.
- [Data needed before build, day 0]: 30-day baseline posting count from both x.com accounts.
- [Assumption] that artifact-anchored drafts (from real things we did today) reduce cringe more than topical takes.

## Strategic Fit

**Strong.** This is now the first product, replacing the `[Needs Human]` placeholder in `strategy/current-strategy.md`. Aligns with the Constitution's main idea — *"put ourselves out in the world by building things and showing them"* (`company-constitution.md:32-35`).

**Requires a separate human action:** update `strategy/current-strategy.md` Primary Customer Segment and Revenue Hypothesis. The AI does not edit Current Strategy silently.

## Principle Check

| # | Principle | Status | Note |
|---|-----------|--------|------|
| 1 | Validate before building | ⚠️ **VIOLATED** | Founder chose to skip the 1-week by-hand validation and build v0 immediately. Noted with eyes open, not silently accepted. The 4-week cadence bar holds us honest in lieu of the missing pre-build test. |
| 2 | One bet at a time | ✅ Pass | This is the single bet. No second bet running. |
| 3 | Scope frozen once set | ✅ Pass | v0 scope frozen below. Mid-build temptations get parked, not added. |
| 4 | Bar pre-registered, does not move | ✅ Pass (served) / ✅ Pass (stranger, deferred) | Both sides named above. Neither moves. |
| 5 | Ambiguous is a kill | ✅ Pass | Bar is binary. Anti-vanity guards named. |
| 6 | Channel sanity check | ✅ Pass | V0 channel: us → x.com (we are User 1). Eventual channel: x.com + indie hacker communities + dogfood posts. Re-check at week 4 verdict before any external launch. |
| 7 | First users by hand; strangers count | ⏸️ Deferred | Activates at week 4+ if cadence holds and we open the external-user question. Re-check at that gate. |
| 8 | Big decisions: written case, no relitigating | N/A | No big written-case decision pending for this idea. |
| 9 | Irreversibility brake | ✅ Pass | Human-in-the-loop per post. No autopublish. Reputation risk bounded. |
| 10 | Discipline over motivation | ✅ Pass | Daily cadence is the discipline being tested. |
| 11 | Work stays visible | ✅ Pass | Posts public. Cadence logged weekly. Verdict written. |
| 12 | Hiring three-part test | N/A | No hiring. |
| 13 | No outside money pre-signal | N/A | No fundraising. |

**Net:** 1 outright violation (P1), 1 deferred (P7), 11 passes / N/A. Not a clean framework pass. Founder override of P1 logged.

## Possible Violations (numbered)

- **P1** — building v0 before the by-hand validation week was run. Founder override, noted.

## Build scope — v0 — FROZEN

**In scope:**
- Input: founder pastes/feeds raw day artifacts (commits, decisions, learnings, what was built).
- Processing: drafts 2–3 tweet-length posts from those inputs.
- Output: 2–3 candidate posts shown to the founder.
- Action: founder picks one, edits freely if wanted, publishes to x.com **manually** (copy-paste or click-through).

**Out of scope (v0) — parked, not added:**
- Scheduling, queueing, autopublish
- Multi-platform (LinkedIn, Threads, etc.)
- Analytics, engagement tracking inside the tool
- Account management, OAuth to x.com
- Visual content, image generation
- Multi-user, sharing, team features
- Fine-tuning, custom model training
- Anything not directly required to draft 2–3 posts from raw inputs

**Build window:** 1 week.

**Build-vs-by-hand reasoning:** Per Constitution `company-constitution.md:137-138`, by-hand is the default and automation is justified when by-hand costs more than building. Founder chose to skip the 1-week by-hand test. P1 violation logged above.

## Smallest validation step (what the 4-week test is checking)

**Day 0:** Pull last 30 days of posting data from both x.com accounts. Record as baseline. (Pre-build, 30 min.)

**Weeks 1–4 (post v0 ship):**
- Both founders use the tool daily.
- Cadence tracked weekly: did each founder post ≥ 5 days that week?
- Each evening, one-line journal: *"would I have posted today without the tool? Why / why not?"* — data for next iteration.

**Week 4 verdict:**
- 4/4 weeks hit ≥ 5/7 → **continue** to stranger-side test (weeks 5–8).
- Any week missed → **kill** or restart hypothesis with different intervention.

## Anti-vanity guards (Principle 5 is at risk here)

- "Felt useful" is not a continue.
- "Sometimes we used it" is not a continue.
- "Cadence was 4/7 — close enough" is not a continue. 4/7 is a kill.
- Likes from existing friends do not count toward any stranger-side bar.
- "We learned a lot from using it" is not a continue. Learning is a side effect; the bar is the cadence number.

## What would make this Approved

A human flips Status → Approved only after:
1. 4 consecutive weeks of ≥ 5/7 cadence held cleanly.
2. Stranger-side bar (≥ 3 inbound from strangers by week 8) hit.
3. Re-check of P6 and P7 passed for external-user opening.

The AI never sets Approved (per `principles/ai-operating-rules.md:46-49`).

## Next Actions

1. **Founder:** Pull 30-day baseline posting count from both x.com accounts. Record in this draft. (Today, ~30 min.)
2. **Founder:** Update `strategy/current-strategy.md` — Primary Customer Segment + Revenue Hypothesis. AI does not edit silently.
3. **Founder:** Build v0 within 1 week, frozen scope above.
4. **Founder:** Start 4-week cadence test on day v0 ships.
5. **AI:** When Notion MCP is authenticated, create Ideas DB entry from this draft, log P1 violation in AI Activity Log, ping Slack with the Needs-Human items (#2 above is the live one).

## Pending storage steps (when Notion MCP is up)

- [ ] Create Ideas DB entry with all fields above.
- [ ] Set Status = Evaluating.
- [ ] Set Next Action = "Pull 30-day baseline + update Current Strategy + build v0 (1 week)."
- [ ] Append to AI Activity Log: `[timestamp] | Ideas/Streak | created | idea-review session, P1 violation logged with founder override`.
- [ ] Slack ping: "IDEA: Streak — founder, you owe (a) baseline pull, (b) Current Strategy update before v0 build starts."

---

## AI Review (formal format per `principles/ai-operating-rules.md:29-42`)

### Summary
Streak — a small tool that drafts 2–3 tweet-length posts/day from the founders' raw day artifacts; founders pick one and publish manually. Targets the publishing-moment friction (cringe, busy, don't-want-to), not ideation. Reframed as the first product over the course of 5 review rounds.

### Strategic Fit
**Strong.** Directly serves the Constitution's "build and show in the open" main idea. Founders are User 1 (matches `current-strategy.md:9-11`).

### Principle Check
**Needs Review.** 11 pass / N/A, 1 outright violation (P1), 1 deferred (P7).

### Possible Violations
- **P1** — v0 build proceeds without the 1-week by-hand validation that the framework requires. Founder override, logged.

### Evidence Level
**Weak.** The two founders are a real named user with a real named problem — that's better than zero. Everything else is [Assumption] until the 4-week cadence test runs.

### Smallest Validation Step
30-day baseline pull (day 0) + 4-week cadence test on v0 (≥ 5/7 days, both founders, no missed weeks). Stranger-side bar activates at week 4 verdict.

### Recommendation
**Validate.** Not Approve — the AI does not approve its own recommendations (`principles/ai-operating-rules.md:64`). Validation path: build v0 in 1 week, run 4-week cadence test, gate the next stage on hitting the pre-registered bar without flexing.

### Required Human Decision
1. Update `strategy/current-strategy.md` — Primary Customer Segment + Revenue Hypothesis.
2. Acknowledge and accept the P1 violation in writing (or reverse the decision and do the by-hand week first).
3. Commit to the 4-week cadence bar without flexing if results are thin.

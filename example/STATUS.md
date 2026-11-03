# Example Ledger — Status

**Last updated:** 2026-03-22
**Phase:** Private beta — 5 bookkeepers, ~2,400 transactions processed. Import + matching live; bulk correction written but unverified.
**Overall:** 🟡 Slipping — bulk edit is one verification away and has been sitting since yesterday; it needs the owner's staging run.

> This file describes **what is true right now**, not what should be true.
> Plans go in ROADMAP.md. Reasoning goes in DECISIONS.md.

---

## ▶ Next up

- **Bulk edit — `CODE WRITTEN` 2026-03-21 (D-044), ⏳ pending the owner's staging run.** Select multiple unmatched rows → assign to one invoice → single undo. Written against the staging schema; never executed against a real ledger. **Next action (owner):** step 1 — `cd ~/example-ledger && ./scripts/load-staging.sh` and paste the output back; step 2 follows once that's clean.
- **Fuzzy payer-name matching — `PLANNED` 2026-03-22.** Current step fails on abbreviated business names; ~60% of the accuracy gap traces here. Approach not decided yet — needs a decision entry before any code. Blocked on nothing; just next in line after bulk edit.
- **OFX import for Bank C and Bank E — `BLOCKED` 2026-03-18.** Both emit a date field the parser rejects. Blocked on getting a real sample file from each; the owner asked both users on 03-18, no reply yet.
- **Nightly backup restore drill — `PENDING scheduling`.** Backups run and are verified as *written*; nobody has ever restored one. Given the D-019 constraint depends on restore working, this should not stay untested.

**State vocabulary:** `PLANNED` · `CODE WRITTEN` · `BUILT` · `TESTED` · `SHIPPED` · `LIVE` · `BLOCKED` · `PENDING <thing>`

---

> Each item appears in exactly one section below — the furthest rung it has reached.
> Moving an item forward means deleting the old row, not adding a second one.

## Built

*(Nothing sitting at exactly this rung right now. An empty section is a real answer — don't pad it.)*

## In progress

- Bulk edit — `CODE WRITTEN` 2026-03-21 (D-044), pending the owner's staging run
- Matching accuracy work — `PLANNED` 2026-03-22, no approach chosen yet
- OFX for Bank C and Bank E — `BLOCKED` 2026-03-18 on sample files

## Tested

*(Items move straight from here to Live once the owner confirms; the verification detail travels with them onto the Live row rather than being left behind as a second entry.)*

## Live

- Queued import pipeline (CSV + OFX) — `LIVE` 2026-03-20 (D-042). Verified by the owner on staging the same day: 60 MB sample, Firefox + Chrome, large-file timeout confirmed fixed.
- Matching engine (four-tier) — `LIVE` to all 5 beta users since 2026-02-11 (D-014). Verified 2026-03-01 against 2,400 real transactions: 87% correct, 0 incorrect auto-matches, 13% unmatched.
- Session auth, magic-link only — `LIVE` since 2026-01-22 (D-005)
- Nightly backups — `LIVE` since 2026-01-30. Never restore-tested; see Next up.

## Blocked / risks

- **Restore has never been tested.** The D-019 rollback constraint assumes restore works. If it doesn't, a bad migration is unrecoverable rather than a lost day. Resolve with the drill above.
- **Single instance, no failover.** Acceptable at 5 users, not at 50. Revisit before opening beta wider.
- **Matching accuracy at 87% against a 95% target.** Users tolerate unmatched rows; the risk is that patience runs out before the fuzzy-name work lands.

---

## History

- 2026-03-20 — v0.2: queued imports, larger file support (D-038, D-042)
- 2026-02-11 — private beta opened, 5 users; matching engine live
- 2026-01-22 — first end-to-end reconciliation on real data

---

## How to update this file

Whoever starts or finishes work updates the relevant row **and** the date at the top. New decisions go to DECISIONS.md first, then get reflected here. When this file passes ~1500 lines, compact it.

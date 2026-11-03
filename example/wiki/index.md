# Example Ledger — project context pack

**Last updated:** 2026-03-22

Read this first at the start of a session, then drill into the one page you need. The point of this folder is **token economy**: read these distilled pages instead of re-deriving things from source or re-reading the whole of `STATUS.md`. When you change a component or make a decision, update the relevant page here — it's cheap, and it's what keeps this true.

---

## Pages

*(In this example the component pages themselves aren't included — only this index. In a real project each name below is a link.)*

- **import-spec** — CSV/OFX upload → validation → queued parse → `transactions` rows. Covers the format sniffer, the 11 bank dialects handled, and the failure taxonomy. **Shipped 2026-03-20 (D-042); the OFX path is the weak one — two of five beta banks emit a date field the parser rejects, currently `BLOCKED` awaiting sample files.**
- **matching-spec** — the reconciliation engine: exact match → amount+date window → fuzzy payer name → unmatched. Scoring, thresholds, and why it never auto-matches below 0.9. **Shipped 2026-02-11 (D-014); accuracy holding at ~87% on beta data, target is 95%.**
- **bulk-edit-spec** — correcting many matches at once, the top beta complaint. **CODE WRITTEN 2026-03-21, not yet verified — needs the owner to run it against the staging copy of a real ledger.**
- **audit-trail-spec** — append-only log of every match, unmatch, and edit, with who and when. Non-negotiable for the accountant-handoff stage. **PLANNED — design only, no code (D-035).**

---

## One-line status

Private beta, 5 bookkeepers, ~2,400 transactions processed. Import and matching are live and holding up; bulk correction is written but unverified, and it's the thing beta users ask about most. Hosted on a single managed instance with nightly backups. No billing yet.

---

## Current priority order (set by the owner)

Strategic sequencing lives in **ROADMAP.md**. This is the near-term tactical order.

1. **Bulk edit — verify and ship.** Code is written and unverified; it's the #1 beta ask (FEEDBACK.md, 4 of 5 users). **Immediate:** the owner runs it against the staging ledger copy and reports what breaks.
2. **Matching accuracy 87% → 95%.** Mostly the fuzzy payer-name step, which fails on abbreviated business names ("J SMITH CONSULT LT"). See `matching-spec`.
3. **OFX import robustness.** Two of five beta banks are rejected outright; both users have fallen back to CSV export, which is why this sits third rather than first. `BLOCKED` on sample files.

Later: audit trail (D-035), multi-client switching, billing. Deliberately deferred — see ROADMAP "Deliberately deferred" so these don't get re-proposed as new ideas.

> This order is set by the owner, not the agent. An agent can propose changes to it; it doesn't make them.

---

## Hard constraints (don't forget)

Every line is here because something already went wrong once.

- **Update STATUS.md + the relevant wiki page every session.** Whatever you touch or decide, reflect it before you finish. This is how "check what's next and start" works cold.
- **The owner is not a coder.** Any terminal step needs the exact command as a copy-paste block, including the `cd`, one step at a time, with a request to paste the output back. "Run the migration and then deploy" is not actionable; two numbered command blocks are.
- **Deploy before migrating, never after.** Reversed, the old app writes rows the new schema rejects and the seed data corrupts. There is no clean rollback — it's a manual restore from the nightly backup, which loses a day. See D-019.
- **Never run anything against production without an explicit go-ahead in the same message.** Beta users' books are their actual livelihood. Staging has a sanitized copy; use it.
- **Don't propose moving off the current queue library.** Evaluated twice (D-007, D-036). It loses on retry semantics, which is the one thing imports need. If you think there's a new reason, say what changed.
- **Money is stored in integer cents, never floats.** A float crept in during the first import build and produced off-by-a-penny reconciliation failures that took two days to find. See D-011.
- **The private repo is `example-ledger-private`; the public one is docs-only.** `backup.sh` refuses to push if origin points at the public repo. DECISIONS/ROADMAP/FEEDBACK are not public material — FEEDBACK quotes beta users by circumstance.
- **The matcher never auto-commits below a 0.9 score.** A wrong auto-match is far more expensive to a bookkeeper than an unmatched row — they trust the tool and don't re-check. Lowering the threshold to improve the accuracy number is not an improvement.

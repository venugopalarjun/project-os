# Example Ledger — Project Index

> Example Ledger reconciles bank transactions against invoices for freelance bookkeepers — the ones managing 15–40 small clients in spreadsheets, who lose a day a month to matching payments by hand.

**Last updated:** 2026-03-22
**Where we are:** Private beta with 5 bookkeepers; import and matching work, bulk correction doesn't yet. See STATUS.md.

## ▶ New session? Start here

To pick up work in a fresh session ("check what's next and start"):

1. Read **`wiki/index.md`** — the context pack. It has the **current priority order (set by the owner)**, the one-line status, and the hard constraints. This is where "what's next" actually lives.
2. Read **STATUS.md** — the live source of truth for what's built / testing / blocked. Find the top open item under the current priority.
3. For the *why* and the long-range plan, see **ROADMAP.md** and **VISION.md**.
4. Then start on the highest-priority open task, following the operating rules below.

Do not read every file. Read what the priority points at.

## Documents

| File | Purpose |
|------|---------|
| VISION.md | What Example Ledger is, who it's for, what it refuses to be |
| ROADMAP.md | Stages: Beta Hardening → Multi-client → Accountant Handoff |
| [STATUS.md](STATUS.md) | Live status: built / in progress / tested / live / blocked |
| [DECISIONS.md](DECISIONS.md) | Decision log — D-001 onward, newest first |
| ARCHITECTURE.md | Stack, data flow, and why each piece was picked |
| FEEDBACK.md | Raw beta feedback + deduplicated open asks |
| SETUP.md | Getting a local copy running, step by step |
| RECOVERY.md | Getting everything back on a new machine |
| [wiki/](wiki/) | Distilled component specs — read these instead of the source |

*(In this example only the linked files exist — the rest follow the templates directly.
In a real project every row is a live link.)*

## Conventions (operating rules — every session)

- **Update as you go, every session.** Before ending a session, update **STATUS.md** (the live rows + the date at top) *and* the relevant **`wiki/` page** for anything touched or decided. This is how the next session starts cold. Cheap to update, expensive to skip.
- **Decisions before code.** Every non-trivial choice gets an entry in **DECISIONS.md** before it's implemented or reflected anywhere else.
- **One question, one file.** STATUS.md holds live state; VISION/ROADMAP hold direction; `wiki/` holds component detail. Never duplicate a fact across two files.
- **Date everything.** Every doc carries a "Last updated" line at the top.
- **Written ≠ verified.** Distinguish code written / built / confirmed working. Never report something as done that the owner hasn't confirmed by using it.
- **Respect the hard constraints** in `wiki/index.md`. Each line is there because something already went wrong once. Don't re-propose what's on that list without saying why the constraint no longer holds.
- **The owner is not a coder.** Any terminal step comes as an exact copy-paste block including the `cd`, one step at a time, with a request to paste the output back before continuing. Never "just run the migration" — give the command.
- **Back it up.** `bash backup.sh` at the end of every session, same moment as the STATUS update. Nightly cron as the safety net. See RECOVERY.md.
- **Nothing touches production data without an explicit go-ahead in the same message.** Beta users' books are their livelihood.

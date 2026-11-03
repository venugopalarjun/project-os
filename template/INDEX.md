# {{PROJECT_NAME}} — Project Index

> {{One sentence: what this is, who it's for, and what makes it different.}}

**Last updated:** {{YYYY-MM-DD}}
**Where we are:** {{ONE sentence of orientation — enough to know roughly what stage this is at. Everything else lives in STATUS.md; do not let this grow into a status report.}}

## ▶ New session? Start here

To pick up work in a fresh session ("check what's next and start"):

1. Read **`wiki/index.md`** — the context pack. It has the **current priority order (set by {{OWNER}})**, the one-line status, and the hard constraints. This is where "what's next" actually lives.
2. Read **STATUS.md** — the live source of truth for what's built / testing / blocked. Find the top open item under the current priority.
3. For the *why* and the long-range plan, see **ROADMAP.md** and **VISION.md**.
4. Then start on the highest-priority open task, following the operating rules below.

Do not read every file. Read what the priority points at.

## Documents

| File | Purpose |
|------|---------|
| [VISION.md](VISION.md) | What this is, why it exists, the full picture |
| [ROADMAP.md](ROADMAP.md) | Feature index: one row per feature, flip the status cell when it moves |
| [STATUS.md](STATUS.md) | Live status: built / in progress / tested / live / blocked |
| [DECISIONS.md](DECISIONS.md) | Decision log — what was decided, when, and why |
| [ARCHITECTURE.md](ARCHITECTURE.md) | How it's built; stack choices and rationale |
| [FEEDBACK.md](FEEDBACK.md) | Raw user feedback + a deduplicated list of open asks |
| [SETUP.md](SETUP.md) | How to get this running from scratch |
| [RECOVERY.md](RECOVERY.md) | How to get everything back if this machine dies |
| [DESIGN.md](DESIGN.md) | Design system: colours, type, spacing, components (if anything is visual) |
| [CHECKS.md](CHECKS.md) | What must be true before anything ships (runs automatically once scripted) |
| [wiki/](wiki/) | Distilled component specs — read these instead of re-deriving |
| `*-Wireframe.html` | Approved wireframes, one per visual feature |

## Conventions (operating rules — every session)

1. **Update as you go, every session.** Before stopping, update **STATUS.md** (date + "▶ Next up"), the **ROADMAP.md** status cells, and the relevant **`wiki/` page**. Cheap to do, expensive to skip.
2. **Decisions before code.** Every non-trivial choice gets a `D-###` entry in **DECISIONS.md** first.
3. **New asks go through FEEDBACK.md first.** Log as an `A-##`, then promote to a ROADMAP row.
4. **One question, one file.** Never duplicate a fact across two files.
5. **Date everything.** Every doc carries a "Last updated" line at the top.
6. **Written ≠ shipped ≠ verified.** Never report something as done that {{OWNER}} hasn't confirmed.
7. **{{OWNER}} sets priorities.** The agent proposes; it doesn't decide.
8. **Respect the hard constraints** in `wiki/index.md`. Don't re-propose anything on that list without saying why it no longer holds.
9. **Wireframe first for anything visual.** HTML wireframe → {{OWNER}} approves → decision logged → build. Use DESIGN.md.
10. **A fixed bug leaves a test behind,** or it isn't fixed.
11. **Checks run before anything ships.** Everything in CHECKS.md, ideally by script, before every release.
12. **Back it up.** Run `bash backup.sh` at the end of a session, alongside the STATUS update. See RECOVERY.md.
- {{PROJECT-SPECIFIC RULE — e.g. "{{OWNER}} is not a coder: give EXACT commands as a copy-paste block, one step at a time, and ask for the output back before continuing."}}
- {{PROJECT-SPECIFIC RULE — e.g. "Component X only builds on {{OWNER}}'s machine; every change to it round-trips through them."}}

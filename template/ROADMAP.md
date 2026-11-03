# {{PROJECT_NAME}} — Roadmap

**Last updated:** {{YYYY-MM-DD}}

{{Short strategy preamble: the stages or arc in 5–10 lines, e.g. "S0 make it work for me → S1 first outside users → S2 public launch". The long "why" lives in VISION.md.}}

Live detail lives in STATUS.md. This file is the map: every feature, one row each, and where it stands.

---

## How this file works

Each feature is one row. When something moves, flip one cell.

- **Track** — the workstream (add a new one whenever a genuinely new workstream appears)
- **Area** — the part of the product it touches
- **Priority** — P0 must · P1 high · P2 should · P3 nice to have. **Set by {{OWNER}}.**
- **Stage** — strategic stage tag (S0…Sn, or — for cross-cutting work)
- **Notes** — one line: version shipped, `D-###` / `A-##` reference, or the blocker

| Status | Meaning |
|---|---|
| ⬜ Not started | On the roadmap, no work yet |
| 🔨 In progress | Being built, or built but not yet released |
| 🚢 Shipped | Released, not yet confirmed working by {{OWNER}} |
| ✅ Verified | Confirmed working by {{OWNER}} |
| ⛔ Blocked | Waiting on something (say what) |
| 💤 Deferred | Intentionally postponed |
| ✂️ Cut | Decided not to do (kept so it isn't re-proposed) |

**Intake:** new asks land in FEEDBACK.md first as an `A-##`. When one is worth tracking, add a row here with ⬜, a priority and the `A-##` in Notes. A material change in scope or priority also gets a DECISIONS.md entry.

---

## {{Track 1, e.g. Core}}

| Feature | Area | Status | Priority | Stage | Notes |
|---|---|---|---|---|---|
| {{Feature}} | {{Area}} | ⬜ Not started | P1 | S0 | {{A-01}} |
| {{Feature}} | {{Area}} | 🔨 In progress | P0 | S0 | {{D-004}} |

## {{Track 2, e.g. Onboarding}}

| Feature | Area | Status | Priority | Stage | Notes |
|---|---|---|---|---|---|
| {{Feature}} | {{Area}} | ⬜ Not started | P2 | S1 | {{…}} |

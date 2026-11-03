# {{PROJECT_NAME}} — Status

**Last updated:** {{YYYY-MM-DD}}
**Phase:** {{Where the project is overall — e.g. "Private beta on one platform." Keep it to one or two sentences.}}
**Overall:** 🟢 On track / 🟡 Slipping / 🔴 Blocked — {{one line on why}}

> This file describes **what is true right now**, not what should be true.
> Plans go in ROADMAP.md. Reasoning goes in DECISIONS.md.

---

## ▶ Next up

The 3–8 things actually in play, most urgent first. Each entry: what it is, its state, its date, and what unblocks it.

- **{{Item}} — {{STATE}} {{YYYY-MM-DD}} ({{D-0XX}}):** {{What it is in one or two sentences. What's done, what's left, and the specific next action — including the exact command or step if a human has to run it.}}
- **{{Item}} — {{STATE}} {{YYYY-MM-DD}}:** {{...}}

**State vocabulary** (use these exact words):
`PLANNED` · `CODE WRITTEN` · `BUILT` · `TESTED` · `SHIPPED` · `LIVE` · `BLOCKED` · `PENDING <thing>`

`CODE WRITTEN` ≠ `BUILT` ≠ `TESTED`. Never skip a rung.

---

## Built

Done and working. One line each.

- {{Thing}} — {{YYYY-MM-DD}}

## In progress

Started, not finished. Note what's blocking each one.

- {{Thing}} — {{state}}, blocked on {{what}}

## Tested

Verified working, by whom, on what.

- {{Thing}} — verified {{YYYY-MM-DD}} by {{who}} on {{what}}

## Live

Shipped to real users.

- {{Thing}} — live since {{YYYY-MM-DD}} at {{where}}

## Blocked / risks

Known problems, with severity and who owns them.

- **{{Risk}}** — {{impact}}. {{What would resolve it.}}

---

## History

Older shipped items, collapsed to one line each. Move things here once they stop being relevant to current work.

---

## How to update this file

Whoever starts or finishes work updates the relevant row **and** the date at the top. New decisions go to DECISIONS.md first, then get reflected here. When this file passes ~1500 lines, compact it.

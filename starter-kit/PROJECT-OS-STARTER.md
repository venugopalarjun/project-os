# Project OS — Starter Kit

**Last updated:** 2026-11-03

> **The folder is the memory. The agent is disposable.** A brand-new session reads two short files and knows where the project stands, what's next, and what not to do. Because it's plain markdown, it works with any AI tool, or none.

---

## 0. What's in this kit

1. **This file.** Drop it in the new project's folder and tell your AI tool: *"Set up this project using PROJECT-OS-STARTER.md."*
2. **`backup.sh`** (ships alongside this file). It's a generic backup script with guards. Fill in its CONFIGURE block before the first run. It's optional, but strongly recommended.
3. **Project instructions.** Paste the block in §6 into the new project's instructions.

The kit is fully self-contained. It doesn't reference any other project, folder or repository, and nothing in it needs to be fetched from elsewhere.

### Isolation rule (read first)

This project is standalone. Your AI tool must **only read and write inside this project's own folder**, and the project gets its **own new private git repo**. Never reuse, clone or push to another project's repo, and never copy files across from another project's folder. If a path, remote or file seems to belong to a different project, stop and ask the owner.

---

## 1. Folder structure

```
<Project>/
├── INDEX.md            Front door: what this is, how to start a session, file table, operating rules
├── VISION.md           What it is and why it exists (rarely changes)
├── ROADMAP.md          Flat feature index: one row per feature, flip a status cell when it moves
├── STATUS.md           What is true RIGHT NOW: newest first, "▶ Next up" at top
├── DECISIONS.md        Decision log D-001, D-002…: newest first, what + why
├── FEEDBACK.md         Raw user/stakeholder asks → deduplicated A-## list → promoted to ROADMAP
├── ARCHITECTURE.md     How it's built; stack choices and the reasons for them
├── SETUP.md            How to run it from scratch
├── RECOVERY.md         How to get everything back if this machine dies
├── DESIGN.md           (if visual) Design system: colour/type/spacing tokens, components
├── CHECKS.md           (once you ship) What must be true before any release; scripted later
├── <Thing>-Wireframe.html   (if visual) One approved HTML wireframe per feature
├── AGENTS.md           (optional) Copy of the project instructions, if your AI tool uses this filename
├── backup.sh           Commit + push to a PRIVATE repo, with guards
├── wiki/
│   ├── index.md        Context pack: priority order, one-line status, page list, HARD CONSTRAINTS
│   └── <component>-spec.md   One distilled spec per component/feature
├── skills/             (optional) Project-specific house skills, e.g. a writing voice
└── tests/              (if code) Regression tests; "a fixed bug leaves a test behind"
```

**Rule of the structure: one question → one file.** Never let two files answer the same question. That's how they drift apart.

| File | Answers | Changes |
|---|---|---|
| INDEX.md | Where do I start, what are the rules? | Rarely |
| wiki/index.md | What's the priority, and what must I never get wrong? | When priorities shift |
| VISION.md | What is this and why? | Rarely |
| ROADMAP.md | What features exist/are planned, and their status? | Flip cells as things move |
| STATUS.md | What's true right now? | Every session |
| DECISIONS.md | What did we decide, and why? | On every decision |
| FEEDBACK.md | What are people asking for? | As asks arrive |
| ARCHITECTURE.md | How is it built? | On structural change |
| wiki/*-spec.md | How does component X work / what's the plan? | When X changes |
| DESIGN.md | How should it look? | When the design system changes |
| CHECKS.md | What must be true before shipping? | When something ships broken |

---

## 2. Session protocol (the load protocol)

**Start of every session: load in layers. Don't read the big files whole.** STATUS and DECISIONS are append-only and grow huge, so reading them in full burns the context window before any work starts.

1. Read **INDEX.md** and **wiki/index.md**. Together they should be about 4k tokens or less.
2. Read only the **top of STATUS.md** (it's newest first): the header, the phase, and "▶ Next up".
3. Pull the rest **on demand**: grep DECISIONS.md for a specific `D-###`, open the one `wiki/` spec for the component you're touching, and check ROADMAP/VISION for the strategic "why".
4. Start on the highest-priority open item.

**End of every session:**

1. Update **STATUS.md**: refresh the date and phase line, and add or adjust the "▶ Next up" rows.
2. Flip the relevant **ROADMAP.md** status cells and refresh their one-line Notes.
3. Update the **wiki/** page for anything touched or decided.
4. Run **`bash backup.sh`**.

---

## 3. Operating rules (copy into INDEX.md → Conventions)

1. **Update as you go, every session.** STATUS + ROADMAP cells + the wiki page, before stopping. It's cheap to do and expensive to skip.
2. **Decisions before code.** Every non-trivial choice gets a `D-###` entry in DECISIONS.md *first*, then gets reflected elsewhere.
3. **New asks go through FEEDBACK first.** Log the ask in FEEDBACK.md (raw report + an `A-##` row in the deduplicated list), then **promote** it to a ROADMAP row (Status ⬜, Track, Area, Priority, and a `D-###`/`A-##` ref). If no Track fits, add one. Material scope or priority changes need a DECISIONS entry.
4. **One question, one file.** No duplicated state.
5. **Date everything.** Every doc starts with `**Last updated:** YYYY-MM-DD`.
6. **Written ≠ shipped ≠ verified.** Code written, built or shipped, and confirmed working by the owner are three different states. Never call something done that the owner hasn't confirmed.
7. **The owner sets priorities.** The agent can propose a priority, but it doesn't decide one.
8. **Respect the hard constraints** in wiki/index.md. Don't re-propose anything on that list without saying why the constraint no longer holds.
9. **Visual changes: wireframe first.** For any UI, produce an HTML wireframe (`<Thing>-Wireframe.html`), get the owner's approval, log it as a decision, *then* build.
10. **A fixed bug leaves a test behind,** or it isn't fixed. (Code projects only.)
11. **Checks run before anything ships.** Keep CHECKS.md; once it's more than a few lines, turn it into a script the release/publish step runs first, which stops on any failure.
12. **Back it up off this machine.** Use a private repo, at the end of every session.
12. *(If the owner isn't a coder)* For any terminal step, give the **exact** commands as a copy-paste block (include `cd`, no placeholders), **one step at a time**, and ask for the output to be pasted back before continuing.

---

## 4. File templates

### INDEX.md (keep it under ~80 lines)

```markdown
# {{Project}} — Project Index

> {{One sentence: what it is, who it's for, what makes it different.}}

**Last updated:** {{YYYY-MM-DD}}
**Where we are:** {{ONE sentence. Everything else lives in STATUS.md.}}

## ▶ New session? Start here
Load in layers — do NOT read STATUS.md, DECISIONS.md or wiki/ in full.
1. Read INDEX.md + wiki/index.md (priority order, one-line status, hard constraints).
2. Read only the top of STATUS.md (newest-first): header + ▶ Next up.
3. Pull on demand: grep DECISIONS.md for a D-###; open only the wiki spec you need; ROADMAP/VISION for the why.
4. Start the highest-priority open task, following Conventions below.

## Documents
| File | Purpose |
|---|---|
| VISION.md | What this is and why |
| ROADMAP.md | Flat feature index (status cells) |
| STATUS.md | Live state, newest first |
| DECISIONS.md | Decision log (D-###) |
| FEEDBACK.md | Asks log (A-##) → promoted to ROADMAP |
| ARCHITECTURE.md | How it's built |
| SETUP.md / RECOVERY.md | Run from scratch / restore after loss |
| wiki/ | Distilled component specs |

## Conventions (operating rules — every session)
{{paste §3 here, trimmed to what applies}}
```

### wiki/index.md: the context pack

```markdown
# {{Project}} — context pack

**Last updated:** {{YYYY-MM-DD}}

Read this first, then drill into the one page you need. Update the relevant page whenever you change a component or make a decision.

## Pages
- [[{{component}}-spec]] — {{one line: what it is + current state (e.g. "shipped 2026-10-01, D-012; next: X")}}

## One-line status
{{Two or three sentences max.}}

## Current priority order (set by {{Owner}})
1. {{…}}
2. {{…}}

## Hard constraints (don't forget)
<!-- Each line exists because something already went wrong once. Cite the D-###. -->
- {{e.g. "Owner is not a coder — exact copy-paste commands, one step at a time."}}
- {{e.g. "X only builds on the owner's machine; every change to it round-trips through them."}}
- {{e.g. "Don't propose replacing library Y — evaluated twice, loses on Z. See D-007."}}
```

### ROADMAP.md: flat feature index

```markdown
# {{Project}} — Roadmap

**Last updated:** {{YYYY-MM-DD}}

{{Short strategy preamble: the stages/arc in 5–10 lines. Detail lives in VISION.md.}}

## How this file works
Each feature is one row. When something moves, flip one cell.
- **Track** — workstream (extensible; add one when a new workstream appears)
- **Area** — product surface/component it touches
- **Priority** — P0 must · P1 high · P2 should · P3 nice
- **Stage** — strategic stage tag (S0…Sn, or — for cross-cutting)
- **Notes** — one line: version, D-###/A-## ref, or blocker. Detail goes in STATUS.md.

| Status | Meaning |
|---|---|
| ⬜ Not started | Planned, no work yet |
| 🔨 In progress | Being built / built-not-shipped |
| 🚢 Shipped | Released, not yet confirmed by {{Owner}} |
| ✅ Verified | Confirmed working by {{Owner}} |
| ⛔ Blocked | Waiting on something (say what) |
| 💤 Deferred | Intentionally postponed |
| ✂️ Cut | Decided not to do (kept for the record) |

## Features
| Feature | Track | Area | Status | Priority | Stage | Notes |
|---|---|---|---|---|---|---|
| {{…}} | {{…}} | {{…}} | ⬜ | P1 | S0 | A-01 |
```

### STATUS.md

```markdown
# {{Project}} — Status

**Last updated:** {{YYYY-MM-DD}}
**Phase:** {{one line}}
**Overall:** 🟢/🟡/🔴 {{one line + latest headline}}

## ▶ Next up
<!-- Newest first. Each row: emoji · bold headline · state (built / ⏳ waiting on X / ✅ verified) · D-### · what's next. -->
- 🔨 **{{Thing}} — built ({{date}}, D-###), ⏳ {{owner}} to test.** {{one or two lines of detail}}

## Log
<!-- Older detail, newest first. Compact when this passes ~1,500 lines (move old entries to STATUS-ARCHIVE.md). -->
```

### DECISIONS.md

```markdown
# {{Project}} — Decision Log

**Last updated:** {{YYYY-MM-DD}} (D-### — {{headline}})
Newest first. Format: ID · date · decision, then rationale and status.

## D-002 · {{YYYY-MM-DD}} · {{Decision headline}}
**Context:** {{what forced the choice}}. **Options:** {{A / B / C}}. **Chose:** {{B}} — {{owner's words if they chose}}.
**Why:** {{rationale}}. **Reverses/extends:** {{D-### or —}}. **Status:** {{decided / built / verified}}.
```

### FEEDBACK.md

```markdown
# {{Project}} — Feedback Log

**Last updated:** {{YYYY-MM-DD}}

## Open asks (deduplicated, running list)
| # | Ask | Source(s) | Area | Status |
|---|---|---|---|---|
| A-01 | {{the ask + any diagnosis}} | {{who, date}} | {{area}} | Open / → ROADMAP (D-###) / Done |

## Raw reports (newest first)
### {{YYYY-MM-DD}} · {{who}}
{{verbatim-ish report}}
```

### DESIGN.md (only if anything is visual)

```markdown
# {{Project}} — Design system
**Last updated:** {{YYYY-MM-DD}}
The single source of truth for how it looks. Wireframes and code both use these values.
## Principles  (2–4 lines)
## Colour tokens  (name · light value · dark value · use; text must pass WCAG AA contrast)
## Type  (display / heading / body / label: font, size, weight)
## Spacing, radius, elevation
## Components  (button, card, pill…: purpose, states, tokens used)
## Writing  (voice; buttons say what happens)
```

### CHECKS.md (once you ship anything)

```markdown
# {{Project}} — Checks
**Last updated:** {{YYYY-MM-DD}}
What must be true before anything ships. Each line exists because something broke once; point it at the D-### or A-##.
How to run: {{command}} · Runs automatically: {{yes, first step of publish / no}}
- [ ] Version bumped before building
- [ ] All tests pass
- [ ] Install/download works on a clean machine
- [ ] No secrets or private data in anything published
- [ ] {{The thing that broke last time}} ({{D-0XX}})
```

### Wireframes (only if anything is visual)

One self-contained `<Thing>-Wireframe.html` per feature in the project root: every state (empty, normal, error), real copy, DESIGN.md tokens, short lettered notes beside each frame. The owner approves it and the approval is logged as a decision before any code is written.

### wiki/<component>-spec.md

```markdown
# {{Component}} — spec

**Last updated:** {{YYYY-MM-DD}} · **Status:** {{⬜/🔨/🚢/✅}} · **Decisions:** D-###

## What and why
## How it works (data flow, files, key functions)
## Build plan / increments (each marked done/pending)
## Open questions
## Verification (how we know it works; what the owner confirmed)
```

VISION, ARCHITECTURE, SETUP and RECOVERY are free-form. Each carries a "Last updated" line and answers only its own question. RECOVERY.md should be written as if you have a new machine and nothing else: what's backed up, what isn't, and the exact restore steps.

---

## 5. Backup

Use the `backup.sh` that ships with this kit. It finds its own folder (wherever the script sits), so it only ever backs up this project. It stages everything, then **refuses to push** if it finds secrets or tokens, oversized files, paths you marked private, or a remote that looks public. It also recovers from a stale `index.lock` and retries commits whose push failed earlier.

One-time setup:

1. Create a **new, private** repo for this project only. Never reuse another project's repo.
2. `git init` and `git remote add origin <this-project's-private-url>`. Check it with `git remote -v` before the first push.
3. Fill in the CONFIGURE block (private paths, max file size, and `FORBIDDEN_REMOTE`, a pattern matching any repo this project must never push to, such as other projects' repos or a public site repo).
4. Write a `.gitignore` that excludes private data, build output, models and secrets.
5. Run `bash backup.sh --dry-run`, then run it for real.

macOS can't run the backup from `launchd` while the project sits in a protected folder like `~/Documents`, because that folder is protected. Run it manually at the end of each session. Set an ordinary calendar or task reminder to check `backup.log` if you need a safety net.

---

## 6. Project instructions to paste into your AI tool

```
The user is working in their local project "{{Project}}". Every new session, follow the load protocol and Conventions in INDEX.md (start by reading INDEX.md + wiki/index.md; do not read STATUS.md, DECISIONS.md or wiki/ in full). Update STATUS.md, the ROADMAP.md status cells, and the wiki/ page as you go; new asks → FEEDBACK.md then promote to ROADMAP; new decisions → DECISIONS.md first. Only read and write inside this project's own folder; it has its own private repo. Back up at session end: bash {{full path to this project's folder}}/backup.sh
```

---

## 7. Setting it up (for an AI tool, in the new project)

1. Interview the owner briefly: name, one-sentence pitch, owner name, the current top 3 priorities, the known hard constraints, whether they code, and whether they want backup now.
2. Scaffold every file in §1 from the §4 templates (DESIGN.md, CHECKS.md and wireframes only if the project has a visual or shipped side), filled in with the owner's answers. Don't leave empty `{{braces}}`; for anything still unknown, write "TBD — ask {{Owner}}".
3. Log **D-001 · Adopt Project OS structure** in DECISIONS.md. Start every ID series fresh (D-001, A-01).
4. Seed ROADMAP with the known features and FEEDBACK with any existing asks.
5. Set up backup.sh (§5) if the owner wants it.
6. Read back to the owner the hard constraints list and the priority order. Those two are what they must own.

**Don't try to be exhaustive on day one.** Get INDEX.md and the constraints list right, and let the rest accumulate. The structure is easy. The habit of updating every session is the actual product.

## Anti-patterns

- Putting wishes in STATUS. STATUS is state; plans belong in ROADMAP.
- Letting the agent set priorities.
- Wiki pages that just relocate code instead of explaining it.
- Endless append. Compact STATUS and DECISIONS past ~1,500 lines into an archive file, and leave a pointer behind.
- Reading every file at session start. That's what the layered load protocol prevents.

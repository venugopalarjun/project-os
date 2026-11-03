---
name: project-os
description: >-
  Set up and maintain a Project OS folder — a plain-markdown structure
  (INDEX / STATUS / DECISIONS / ROADMAP / wiki context pack) that lets any AI
  agent cold-start on a long-running project in one read. Use when someone asks
  to set up or retrofit Project OS, scaffold a project folder for AI
  collaboration, stop re-explaining their project every session, log a decision
  to DECISIONS.md, update STATUS.md, write a wiki component spec, cold-start on
  a project that already has this structure, compact a bloated status or
  decision log, or set up backup and recovery for a project folder that exists
  only on one machine. Triggers — "set up project os", "retrofit project os",
  "scaffold my project folder", "I keep re-explaining my project to the AI",
  "log this in the decision log", "update STATUS.md", "distill this into a wiki
  spec", "my decision log is too long", "read the context pack and pick up
  where we left off", "is my project folder backed up", "write a RECOVERY.md",
  "log this as an ask", "add this to the roadmap", "set up release checks",
  "take this feature from idea to release".
---

# Project OS

Sets up and maintains a plain-markdown folder that acts as a project's external memory, so a fresh agent — in any tool — can orient in one read.

**Core principle: the folder is the memory; the agent is disposable.**

The design goal is that reading `wiki/index.md` and `STATUS.md` is enough to start productive work. When that stops being true, something in the folder is stale — that's the thing to fix.

Full rationale: `reference/conventions.md`. Idea-to-release flow: `reference/workflow.md`. Log maintenance: `reference/compaction.md`. Backup strategy: `reference/backup.md`. Filled-in example: `example/`. All paths are relative to this skill's directory.

---

## The file set

Core files plus a `wiki/` folder. Each answers exactly one question; never let two answer the same one.

| File | Answers | Changes |
|---|---|---|
| `INDEX.md` | Where do I start and what are the rules? | Rarely |
| `VISION.md` | What is this and why does it exist? | Rarely |
| `ROADMAP.md` | Which features exist or are planned, and where each stands | Flip a cell when one moves |
| `STATUS.md` | What is true *right now*? | Every session |
| `DECISIONS.md` | What did we decide and why? | On every decision |
| `ARCHITECTURE.md` | How is it built and what did we pick? | On structural change |
| `FEEDBACK.md` | What are real users saying? | As feedback arrives |
| `SETUP.md` | How do I run this from scratch? | On tooling change |
| `RECOVERY.md` | How do I get this back if the machine dies? | Rarely |
| `DESIGN.md` | How should it look? (only if anything is visual) | On design-system change |
| `CHECKS.md` | What must be true before anything ships? | When a new way to break it is found |
| `wiki/` | One distilled spec per component | On component change |
| `<Thing>-Wireframe.html` | What will this screen look like? | Before any visual change is built |

Blank scaffolds are in `template/`, along with `backup.sh` and `PROJECT-INSTRUCTIONS.md` (the block to paste into the user's AI tool). A worked example is in `example/`.

### The two load-bearing files

**`INDEX.md`** — the front door. One-sentence description, a numbered "New session? Start here" block, a table of files, the operating rules. At most one sentence of current state, and it must point at `STATUS.md` for the rest. Keep it under 60 lines.

**`wiki/index.md`** — the context pack, and the highest-leverage file in the system. It holds one line per component page *including that component's current state*, the current priority order (set by the human), a one-line status of the whole project, and the **hard constraints**.

The constraints list is what people skip. It records the things an agent will otherwise get wrong on every project — environment limits, things already tried and rejected, operations that break something silently. Build it by asking directly: *"what do AI assistants keep getting wrong about your project?"* Then add a line each time an agent makes a mistake that was predictable in hindsight.

---

## Status vocabulary

One vocabulary, used in `STATUS.md`, `DECISIONS.md`, and wiki pages alike:

`PLANNED` → `CODE WRITTEN` → `BUILT` → `TESTED` → `SHIPPED` → `LIVE`, plus `BLOCKED` and `PENDING <thing>`.

The gap between `CODE WRITTEN` and `TESTED` matters more than the rest combined. Reporting work as done when it was only written is the most expensive failure mode in this system, and agents are systematically optimistic about it. Never mark something `TESTED` or beyond that the human hasn't confirmed, and say who confirmed it and on what.

---

## Modes

Identify the mode, then follow that section. Ask if it's unclear.

### Mode 1 — Set up a new project

1. **Interview first, scaffold second.** Ask: what's being built and for whom; what stage it's at; what the person's own constraints are (do they code? what can only they do?); what tools and services are in play; what's already decided and shouldn't be re-litigated.
2. **Copy `template/` into their folder** and fill in what the interview surfaced. Leave the rest as clearly-marked placeholders — an honest `_TBD_` beats an invented answer. Delete the guidance comments as you fill each file.
3. **Write the constraints list in `wiki/index.md` now**, while their frustrations are fresh.
4. **Seed `DECISIONS.md`** with anything already settled, as D-001 onward. Backdate honestly.
5. **Show them the folder and name the trade:** a few minutes at the end of each session buys a cold start on the next one. The structure does nothing without the habit.

### Mode 2 — Retrofit an existing project

As Mode 1, but read the existing material first — notes, chat exports, code comments, READMEs. Extract decisions into `DECISIONS.md`, current state into `STATUS.md`, component detail into `wiki/`. Ask before discarding anything.

The decision log is the hard part: most projects have decisions that were made implicitly and never written down. Surface them by asking *"why is it built this way?"* about anything non-obvious.

### Mode 3 — Log a decision

Every non-trivial choice gets an entry in `DECISIONS.md` **before** it's reflected anywhere else. Newest first, sequential IDs, never reused, never deleted.

```markdown
## D-042 · YYYY-MM-DD · Short title stating the decision, not the topic
**Decision:** what was chosen, specifically enough to act on.
**Mechanism:** how it works — files, settings, sequence. Omit if purely directional.
**Why:** the reasoning, including what was rejected and on what grounds.
         This is the part future sessions need most.
**Status:** <vocabulary term> YYYY-MM-DD — what's left, and the next action.
           Or: superseded by D-0XX.
```

Then update the affected `STATUS.md` row and wiki page, cross-referencing the ID. Reversals get a new entry and a `superseded by` marker on the old one — never a deletion.

### Mode 4 — Update status

`STATUS.md` sections, in order: `▶ Next up` (the 3–8 things actually in play, most urgent first) · `Built` · `In progress` · `Tested` · `Live` · `Blocked / risks` · `History`.

Every entry carries a state term and a date. Entries stay short — what it is, what state, what's next. Reasoning belongs in `DECISIONS.md`; mechanism belongs in the wiki page. Update the "Last updated" date at the top every time.

### Mode 5 — Write or update a component spec

When explaining a component takes more than a paragraph, it earns a page in `wiki/`. Use `template/wiki/_component-spec-template.md`.

The purpose is token economy: one distilled page instead of re-deriving the component from source. A page that isn't substantially shorter than what it describes has failed — distill, don't relocate. Past roughly 300 lines it's either two components or undistilled.

Afterwards, add its one-line entry to `wiki/index.md`, including current state. An unlinked page won't get read.

### Mode 6 — Cold-start a session

1. Read `wiki/index.md` — priority order, one-line status, hard constraints
2. Read `STATUS.md` — find the top open item under the current priority
3. Read only the `wiki/` page for the component you'll touch
4. Skim `DECISIONS.md` headings; read in full only what's relevant
5. Start work

Don't read every file — the structure exists so you don't have to. If something you need isn't in these files, that's a gap: note it and offer to fill it before the session ends.

### Mode 7 — Compact the logs

`STATUS.md` and `DECISIONS.md` grow without bound; past roughly 1500 lines they cost more than they return. **Read `reference/compaction.md` before doing this** — it has the full procedure, including what must never be deleted.

Two rules that apply regardless: never delete a decision (compress it instead, keeping Decision / Why / Status), and always propose the changes for review before making them. Compaction is destructive and agents are overconfident about what's safe to drop.

### Mode 8 — Take a request from idea to release

Follow `reference/workflow.md`: ask → `FEEDBACK.md` (`A-##`) → `ROADMAP.md` row (owner sets priority) → `DECISIONS.md` (`D-###`) → spec in `wiki/` if it's big → wireframe if it's visual (owner approves before code) → build → tests + `CHECKS.md` → owner verifies → release → update STATUS, ROADMAP, FEEDBACK → backup.

Small changes skip steps; say which ones you're skipping. Never skip the owner's approval of a wireframe or the owner's verification.

### Mode 9 — Set up release checks

When the project first ships something to other people, create `CHECKS.md` from `template/CHECKS.md`. Seed it by asking: *"What would be embarrassing or harmful to publish broken?"* and *"What has broken before?"* Each line points at a decision or incident. When the list is longer than about six lines, offer to turn it into a script the release or publish step runs first, which stops the release on any failure. Add a line every time something ships broken that a check could have caught.

### Mode 10 — Set up backup and recovery

The premise cuts both ways: if the folder is the memory, a folder that exists only on this machine is a single point of failure holding every decision and every spec. **Read `reference/backup.md` before doing this.**

1. **Establish what's actually backed up today.** Don't accept "it's on GitHub" — check. The precise question is *"if this machine died right now, which specific files would be gone?"* A public repo for the shipped artifact almost never includes the docs folder.
2. **Check for the two silent traps.** Run `find . -name .git -mindepth 2 -not -path './.git/*'` for nested repos, whose contents `git add -A` skips without saying so. Then look for a `.gitignore` starting with `*` — a whitelist that may be hiding release tooling. Both produce a backup that looks complete and isn't.
3. **Set the scope.** Docs, specs, source, and scripts in. Build output, dependencies, large binaries, logs, and secrets out. Anything genuinely private gets excluded *deliberately* and recorded in `DECISIONS.md` as a privacy decision.
4. **Copy `template/backup.sh`** into the project and fill in all five items in its CONFIGURE block: private paths, size cap, forbidden remotes, `FORCE_ADD` (any file a whitelist `.gitignore` is hiding — step 2), and the token source. Run `--dry-run` first.
5. **Insist the remote is private.** The script can only *verify* this when the GitHub CLI is installed and authenticated; otherwise it warns and proceeds, so confirm by hand. `DECISIONS.md` is strategy, `ROADMAP.md` is unshipped, `FEEDBACK.md` quotes real people by circumstance, and the constraints list maps where the project is weak. None of that is public material.
6. **Write `RECOVERY.md`** from `template/RECOVERY.md`, as though the reader has a new machine and nothing else.
7. **Set both cadences** — manual at end of session (same habit as updating `STATUS.md`) and a nightly scheduled job using the OS's own scheduler, not an AI assistant's task feature, which usually can't reach the credential store.

Never write a credential into the repo, into `git config`, or into the script. Read it from the OS credential store at push time.

---

## The operating rules

Put these in the project's `INDEX.md`, adapted to the project's own wording:

1. **Update as you go, every session** — `STATUS.md`, the `ROADMAP.md` cells and the relevant `wiki/` page, before finishing.
2. **Decisions before code** — every non-trivial choice lands in `DECISIONS.md` first.
3. **New asks go through `FEEDBACK.md` first** — log as an `A-##`, then promote to a `ROADMAP.md` row.
4. **One question, one file** — no duplicated state; pick a home and link from the other.
5. **Date everything** — every file carries a "Last updated" line.
6. **Written ≠ shipped ≠ verified** — code written, released, and confirmed working are different states.
7. **The owner sets priorities** — propose, don't decide.
8. **Respect the constraints list** — it exists because someone already paid for that lesson.
9. **Wireframe first for anything visual** — owner approves, decision logged, then build.
10. **A fixed bug leaves a test behind** — or it isn't fixed.
11. **Checks run before anything ships** — `CHECKS.md`, by script once it's long enough.
12. **Back it up off this machine** — a memory that exists in one place isn't a backup of anything.

Then add the project-specific rules the interview surfaced. Those are usually the ones that actually get used.

---

## The failure to watch for

A structure with no update habit. It is the most common way this goes wrong by a wide margin, and it looks like success for about two months. If a session ends without `STATUS.md` being touched, say so.

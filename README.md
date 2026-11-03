# Project OS

**A plain-markdown operating system that lets one person run a real project with AI, the way a small team would.**

A handful of markdown files, a `wiki/` folder, a backup script and twelve rules. No app, no plugin, no database. It works with any AI tool, or by hand.

**Last updated:** 2026-11-03 · version 2 (see [CHANGELOG.md](CHANGELOG.md))

---

## Why this exists

Working with an AI agent on anything longer than a week breaks in three predictable ways.

- **Amnesia.** Every session starts from zero. You re-explain the project, and the agent quietly contradicts what you decided last week.
- **Lock-in.** Your context lives inside one tool's memory. Switch tools or hit a limit and it's gone.
- **Drift.** What the agent believes and what is actually true slowly come apart. Nobody notices until something built on a wrong assumption breaks.

A better prompt doesn't fix any of these. Putting the memory outside the model does.

> **The folder is the memory. The agent is disposable.**

A fresh session reads two short files and knows where the project stands, what's next, and what not to do.

## What a vibe-coded first version doesn't give you

Getting a first version out of an AI tool takes a weekend. Making something people can rely on takes the rest: knowing why things are built the way they are, catching the things that break only in real use, not breaking them again, and shipping without losing track. Project OS is the set of files and habits that carries that work from one session to the next, so one person can play engineer, product manager, designer, tester and writer without dropping anything.

## What's in here

```
GETTING-STARTED.md   Step-by-step setup, written for non-coders. Start here.
SKILL.md             An optional AI-tool skill that sets up and maintains the folder for you.
starter-kit/         One self-contained file + backup script. Drop into a new
                     project and say "set this up".
template/            Blank versions of every file, plus backup.sh.
example/             Four filled-in files from a fictional project.
reference/           The rules in detail, the end-to-end workflow, log
                     compaction, and backup.
```

## The files in your project

Each file answers exactly one question. Never let two files answer the same one; that's how they drift.

| File | Answers | Changes |
|---|---|---|
| `INDEX.md` | Where do I start, and what are the rules? | Rarely |
| `wiki/index.md` | What's the priority, and what must never go wrong? | When priorities shift |
| `VISION.md` | What is this and why does it exist? | Rarely |
| `ROADMAP.md` | Which features exist or are planned, and where each stands | Flip a cell when one moves |
| `STATUS.md` | What is true right now? | Every session |
| `DECISIONS.md` | What did we decide, and why? | On every decision |
| `FEEDBACK.md` | What are people asking for? | As asks arrive |
| `ARCHITECTURE.md` | How is it built? | On structural change |
| `DESIGN.md` | How should it look? Colours, type, spacing, components | When the design system changes |
| `CHECKS.md` | What must be true before anything ships? | When you learn a new way to break it |
| `SETUP.md` | How do I run this from scratch? | On tooling change |
| `RECOVERY.md` | How do I get it back if this machine dies? | Rarely |
| `wiki/<component>-spec.md` | How does this one part work, and what's the plan? | When that part changes |
| `<Thing>-Wireframe.html` | What will this screen look like? | Before any visual change is built |

`DESIGN.md`, `CHECKS.md` and wireframes only matter if you're building something people look at or install. Skip them otherwise.

## The twelve rules

The folder is scaffolding. These are the actual product.

1. **Update as you go, every session.** `STATUS.md`, the `ROADMAP.md` cells and the relevant `wiki/` page, before you stop.
2. **Decisions before code.** Every non-trivial choice gets a `D-###` entry in `DECISIONS.md` first.
3. **New asks go through `FEEDBACK.md` first.** Log the ask as an `A-##`, then promote it to a `ROADMAP.md` row.
4. **One question, one file.** No duplicated state.
5. **Date everything.** Every file starts with a "Last updated" line.
6. **Written ≠ shipped ≠ verified.** Code written, released, and confirmed working by the owner are three different states.
7. **The owner sets priorities.** The agent can propose; it doesn't decide.
8. **Respect the hard constraints** in `wiki/index.md`. Each line is a lesson someone already paid for.
9. **Wireframe first for anything visual.** Approve the wireframe, log the decision, then build.
10. **A fixed bug leaves a test behind,** or it isn't fixed.
11. **Checks run before anything ships.** The list lives in `CHECKS.md` and runs automatically, so you never have to remember it.
12. **Back it up off this machine,** to a private repo, at the end of every session.

Reasons and edge cases for each: [`reference/conventions.md`](reference/conventions.md). How a request moves from idea to release: [`reference/workflow.md`](reference/workflow.md).

## Getting started

Follow [GETTING-STARTED.md](GETTING-STARTED.md). The short version:

1. Download this repo.
2. Copy `starter-kit/PROJECT-OS-STARTER.md` and `starter-kit/backup.sh` into your project folder.
3. Tell your AI tool: *"Set up this project using PROJECT-OS-STARTER.md."* It interviews you and creates the files.
4. Create a **private** GitHub repo for the project and run the backup once.
5. From then on, start every session with *"Read INDEX.md and wiki/index.md, then pick up the top item"*, and end every session with *"Update STATUS, ROADMAP and the wiki, then back up."*

## What it costs

A few minutes at the end of every session. That's the trade: write down what happened, get a cold start next time.

The most common failure is a beautiful structure and no update habit. It looks like success for about two months.

## Anti-patterns

- **Documenting wishes as state.** `STATUS.md` says what *is*. Plans go in `ROADMAP.md`.
- **Letting the agent set priorities.**
- **Wiki pages that relocate code** instead of explaining it.
- **Endless append.** Past ~1,500 lines, compact the logs. See [`reference/compaction.md`](reference/compaction.md).
- **Reading every file at the start of a session.** Load in layers; that's what the index files are for.
- **Calling it fixed because the symptom went away.** Find the cause, prove it's gone, leave a test.

## Origin

Built from patterns that proved useful on a long-running solo project. Everything project-specific has been removed. It started as a fix for losing context between sessions; the fact that the choice of AI tool stopped mattering once the folder was good enough turned out to be the more useful half.

## License

MIT (see [LICENSE](LICENSE)). Use it, change it, ship it.

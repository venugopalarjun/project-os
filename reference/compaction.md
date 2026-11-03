# Compaction — keeping the logs from eating themselves

`STATUS.md` and `DECISIONS.md` are append-heavy by design. Left alone, they grow past the point where anyone reads them — including the agent, which will start skimming or truncating without telling you.

This is the failure mode that project-structure templates never mention. Everything works beautifully for two months, and then the file that was supposed to save you time becomes the most expensive thing to read in the folder.

## When to compact

**Signals it's overdue:**

- Either file is over ~1500 lines
- You scroll past things that stopped being relevant months ago to find what's current
- An agent starts missing things that *are* in the file
- Reading `STATUS.md` costs more than re-deriving the state

Check quarterly. Compact when two or more signals are true.

## Compacting STATUS.md

`STATUS.md` describes **now**. Anything that stopped being now is dead weight at the top of the file.

**Move to `## History` at the bottom, one line each:**

```markdown
## History
- 2026-03-20 — v0.2 shipped: queued imports, larger file support (D-038, D-042)
- 2026-02-11 — private beta opened
```

Anything shipped more than a few weeks ago and no longer referenced by active work belongs here. If the detail matters, it should already be in a wiki page or a decision entry — and if it isn't, move it there before collapsing the row.

**Delete outright:**

- Duplicate entries for the same thing at different stages (keep the final state)
- Blockers that resolved
- "Next up" items that were done or abandoned
- Historical notes marked superseded by a later entry

**Never delete:** anything explaining why something is broken, any unresolved risk, anything an active item depends on.

**Target:** under 400 lines, with `▶ Next up` visible without scrolling.

## Compacting DECISIONS.md

Different rule: **never delete a decision.** The log's value is that it's complete. But entries can be compressed.

**Compress an old entry** by dropping the **Mechanism** section — once implementation detail lives in a wiki page or the code, it's duplicated here. Keep Decision, Why, and Status forever. Why is the whole point.

Before:

```markdown
## D-014 · 2026-02-09 · One matching engine, shared by import and manual entry
**Decision:** ...
**Mechanism:** [40 lines of implementation detail]
**Why:** ...
**Status:** SHIPPED
```

After:

```markdown
## D-014 · 2026-02-09 · One matching engine, shared by import and manual entry
**Decision:** ...
**Why:** ...
**Status:** SHIPPED 2026-02-11 · mechanism now in wiki/matching-spec.md
```

**Split when it gets long.** Past ~100 entries, move older ones to `DECISIONS-ARCHIVE.md`, keeping the most recent 30–40 in the main file. Link the archive from `INDEX.md`. Keep the ID sequence continuous across both — IDs are permanent handles and must never be reused.

## Compacting wiki pages

Wiki pages should be *rewritten*, not appended to. If a page has accumulated a changelog, that's a signal: the changelog belongs in `DECISIONS.md`, and the page should describe the component as it is today.

A wiki page longer than ~300 lines is either two components or hasn't been distilled. Split it or cut it.

## Doing this with an agent

Compaction is destructive, and agents are overconfident about what's safe to drop.

**Always work in two passes.** First: *"read STATUS.md and propose what should be collapsed into History and what should be deleted outright. Show me the list. Don't change anything yet."* Review it. Then approve the edit.

**Commit first if you're in git.** Or copy the file. Compaction is the one operation here worth being paranoid about.

**Watch for the agent deleting things it doesn't understand.** An entry that reads like noise to a fresh agent may be the note explaining why a workaround exists. When in doubt, collapse rather than delete.

## The habit that avoids most of this

Write entries at the right altitude the first time.

`STATUS.md` entries should be short and pointed — what it is, what state it's in, what the next action is. The reasoning goes in `DECISIONS.md`; the mechanism goes in the wiki page. When status entries turn into essays, the file bloats fast and compaction becomes a real project rather than a ten-minute cleanup.

One line for the state, one link for the depth.

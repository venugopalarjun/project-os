# Conventions, in detail

**Last updated:** 2026-11-03

The twelve operating rules, with the reasoning and the edge cases behind each.

---

## 1. Update as you go, every session

**The rule:** before ending a session, update `STATUS.md` (the affected rows and the date at top) and the relevant `wiki/` page for anything touched or decided.

**Why it's first:** every other rule depends on it. A structure that isn't current is worse than no structure, because it's confidently wrong. An agent that reads a stale `STATUS.md` will build on assumptions that stopped being true two weeks ago, and it won't flag the problem — it has no way to know.

**In practice:** make it the last thing in every session, before you close the tool. If you're working with an agent, put it in the operating rules so the agent does it. Ask for it explicitly if it doesn't: *"update the status file and the relevant wiki page before we stop."*

**The tell that you've stopped doing it:** you start a session by explaining the project. That means the folder didn't do its job, which means it's out of date.

---

## 2. Decisions before code

**The rule:** every non-trivial choice gets an entry in `DECISIONS.md` before it's implemented or reflected anywhere else.

**Why:** the reasoning behind a choice evaporates faster than the choice itself. Three months later you can see *what* you did but not *why*, and you can't tell whether the constraint that forced it still holds. So you either re-litigate it from scratch, or — worse — leave it in place long after the reason expired.

**What counts as non-trivial:** anything you'd have to explain to someone. Anything where you considered an alternative. Anything you might reverse. Anything a future agent might innocently undo.

**The format:**

```markdown
## D-042 · 2026-03-14 · Import runs as a queued job, not inline in the request

**Decision:** file imports are accepted, written to blob storage, and processed
by a background worker. The upload endpoint returns a job ID immediately.

**Mechanism:** upload → blob store → job row in `import_jobs` → worker polls
every 2s → status endpoint the client polls. Retries three times, then parks
the row as `failed` with the parse error attached.

**Why:** three of the five beta users import spreadsheets over 40 MB, which
took long enough inline to hit the platform's request timeout — and a timeout
mid-parse left half a ledger written. Considered raising the timeout: it papers
over the failure rather than fixing it, and doesn't survive a bigger file.
Considered client-side parsing: rejected because the validation rules would
then live in two places (D-031).

**Status:** SHIPPED 2026-03-20
```

**Title the decision, not the topic.** "D-042 · Imports" tells you nothing. "D-042 · Import runs as a queued job, not inline in the request" tells you everything.

**On superseding:** never delete. Mark the old one `superseded by D-0XX` and write a new entry explaining what changed. The record of a reversal — what you believed, what happened, what you believe now — is often the most valuable thing in the log.

**On backdating:** when retrofitting, date decisions when they were *made*, not when they were logged. Add "(logged retroactively)" if it matters.

---

## 3. New asks go through FEEDBACK first

**The rule:** anything someone wants, including your own ideas, lands in `FEEDBACK.md` as a numbered ask (`A-##`) before it's planned or built. When it's worth doing, promote it to a `ROADMAP.md` row that points back at the `A-##`.

**Why:** asks arrive in chats, calls and passing thoughts, and most of them evaporate. Worse, the agent starts building whatever was said last. A single intake point means nothing is lost, duplicates become visible ("three people asked for this in different words"), and building only starts once something has been deliberately promoted.

**In practice:** say *"log this as an ask"*. Keep the raw words in the *Raw* section, quoted, with context; keep the deduplicated table short. Bugs go here too, marked 🐞.

---

## 4. One question, one file

**The rule:** every fact has exactly one home. If two files could hold it, pick one and link from the other.

**Why:** duplicated state always diverges. Always. You update one, forget the other, and now an agent has two contradictory sources and no way to tell which is current.

**The common collisions:**

| Fact | Belongs in | Not in |
|---|---|---|
| What's currently working | `STATUS.md` | wiki pages (`INDEX.md` may carry one orienting sentence, no more) |
| Why something is built a certain way | `DECISIONS.md` | `ARCHITECTURE.md` (link to the ID) |
| What we're going to build | `ROADMAP.md` | `STATUS.md` |
| How a component works in detail | `wiki/<component>.md` | `ARCHITECTURE.md` (link to it) |
| What the priority is | `wiki/index.md` | everywhere else |

`ARCHITECTURE.md` is a map with links. `INDEX.md` is a table of contents with rules, plus at most a single sentence of orientation that points at `STATUS.md` for the rest. Neither is where state lives.

---

## 5. Date everything

**The rule:** every file carries `**Last updated:** YYYY-MM-DD` near the top. Every status entry and decision carries its own date.

**Why:** undated information can't be trusted, so it can't be used. A reader — human or agent — has no way to weigh a claim without knowing when it was made. Dated information that's stale is still useful: you know to check it. Undated information is just noise.

**ISO format, always.** `2026-03-14`. Sorts correctly, unambiguous across regions, greppable.

---

## 6. Written ≠ verified

**The rule:** distinguish code written / built / confirmed working. Never report something as done that the human hasn't confirmed.

**Why this is the expensive one:** an agent writes code, reports it as complete, and moves on. The next session reads `STATUS.md`, sees "shipped," and builds the next thing on top. Nobody has actually run it. Three layers later something breaks and the real cause is four sessions back.

Agents are systematically optimistic about this. They have to be told, in the constraints list, and then held to it.

**Use a fixed vocabulary:**

| State | Means |
|---|---|
| `PLANNED` | Decided, no implementation |
| `CODE WRITTEN` | Written, never executed |
| `BUILT` | Compiles / runs without error |
| `TESTED` | Someone confirmed it does the right thing |
| `SHIPPED` | In the artifact users get |
| `LIVE` | Real users have it |
| `BLOCKED` | Stopped, with a reason |
| `PENDING <thing>` | Waiting on a specific named thing |

The gap between `CODE WRITTEN` and `TESTED` is where projects quietly rot. Make it visible.

**Say who verified, and on what.** "Tested" is weaker than "verified by owner 2026-03-14, staging, 60 MB sample file, Firefox and Chrome."

---

## 7. The owner sets priorities

**The rule:** the agent can propose a priority order. Only the owner decides it. The current order lives in one place, `wiki/index.md`.

**Why:** agents optimise for what's in front of them: the last message, the most interesting problem, the thing that's nearly done. Left alone, priorities drift toward whatever the agent finds tractable. That's not malice; it's the absence of a stake in the outcome.

**In practice:** when an agent suggests reordering, it says why and waits. Roadmap priorities (P0–P3) are set by the owner too.

---

## 8. Respect the constraints list

**The rule:** the hard constraints in `wiki/index.md` are non-negotiable unless explicitly revisited.

**Why:** each line is there because something went wrong. Not theoretically — actually. An agent with no memory of that will make the same suggestion again, confidently, and it'll cost the same time it cost last time.

**How to build the list:** ask yourself, or the person you're helping, *"what do AI assistants keep getting wrong about this project?"* The answers are the constraints. Then add a line every time an agent gets something wrong in a way that was predictable in hindsight.

**Good constraints are specific and actionable:**

> ✅ "Run the deploy before the migration, never after. Reversed order corrupts the seed data and there's no clean rollback — it's a manual restore from backup. See D-019."

**Bad ones are vague:**

> ❌ "Be careful with deploys."

**Include the cost when you can.** "This means a manual restore from backup" is more persuasive to an agent than "don't do this."

---

## 9. Wireframe first for anything visual

**The rule:** any change people will see starts as an HTML wireframe. The owner approves it, the approval is logged as a decision, and only then is it built.

**Why:** a wireframe costs minutes to change; a built screen costs hours, and often a release. It also forces the real questions early: what does the empty state say, what happens on error, what does the button actually do. Agents left to build UI directly make dozens of small choices nobody agreed to.

**In practice:** one self-contained `<Thing>-Wireframe.html` per feature, showing every state, using the tokens in `DESIGN.md`, with short notes beside each frame. See `template/wiki/wireframes.md`.

---

## 10. A fixed bug leaves a test behind

**The rule:** when you fix a bug, add a test that fails without the fix. Otherwise it isn't fixed; it's just not happening right now.

**Why:** AI-written code is changed constantly, and often by an agent that doesn't remember why an odd-looking line is there. The most common way things break again is a later session "cleaning up" a fix. A test is the only memory that defends itself.

**In practice:** also write the *cause* into the decision that records the fix. "Made it work" is not a cause; "the headset reports 48 kHz but sends 16 kHz" is.

---

## 11. Checks run before anything ships

**The rule:** keep a list in `CHECKS.md` of everything that must still be true before a release (links work, privacy page linked, analytics present, nothing private published, version bumped), and run it automatically as the first step of every release or publish.

**Why:** the list grows from things that broke once. Humans forget lists; scripts don't. A publish step that stops itself when a check fails turns "I hope I remembered" into "it can't go out broken".

**In practice:** start with a handful of lines. When the list passes five or six, ask the agent to turn it into a script that the release command runs first. Each line points at the decision or incident behind it.

---

## 12. Back it up off this machine

**The rule:** the folder lives in a private remote as well as on disk, pushed at least daily.

**Why:** the core principle is that the folder is the memory. Take that seriously and the conclusion follows — a folder existing in exactly one place is every decision and every spec sitting on one disk, with no second copy.

**The three things people get wrong:** assuming it's already backed up when the public repo only holds a curated subset; backing up to a *public* remote, when `DECISIONS.md`, `ROADMAP.md` and `FEEDBACK.md` are none of them public material; and backing up everything, which is slow, expensive, and how secrets get committed.

**In practice:** `template/backup.sh` stages, then refuses to push on a credential file, a secret pattern, an oversized file, or a private path. Pair a manual run with the end-of-session `STATUS.md` update — same habit — and add a nightly scheduled job as the safety net. Write `RECOVERY.md` as though you have a new machine and nothing else.

Full detail, including the two setup checks the script can't do for you: `reference/backup.md`.

# The workflow: from an idea to a release

**Last updated:** 2026-11-03

How one request moves through the folder. Each step leaves something behind in exactly one file, so the next session (or a different AI tool) can pick it up cold.

```
ask ─► FEEDBACK (A-##) ─► ROADMAP row ─► DECISION (D-###) ─► spec (wiki/) ─► wireframe ─► build
                                                                                         │
     STATUS + ROADMAP updated ◄── backup ◄── release ◄── owner verifies ◄── checks + tests
```

Small changes skip steps. A typo fix needs none of this. A new feature needs all of it.

---

## 1. Capture the ask → `FEEDBACK.md`

Anything someone wants (a user, a colleague, you) lands here first, as a numbered ask: `A-23 · Export to PDF · from: 2 early users · status: open`. The raw words go in the *Raw* section underneath, quoted, with the context.

**Why first:** nothing gets lost before it's prioritised, and you can see when three people asked for the same thing in different words.

## 2. Promote it → `ROADMAP.md`

When it's worth doing, add one row to the feature index: name, track, area, `⬜ Not started`, a priority (P0–P3), and a note pointing back to `A-23`. The **owner** sets the priority. The agent can suggest one.

## 3. Decide how → `DECISIONS.md`

Before building, write the choice down: what you'll do, how, and *why*, including what you considered and rejected. Give it the next `D-###`. If the ask is big, this is also where you write down what you are *not* doing.

## 4. Write the spec → `wiki/<component>-spec.md`

Only when the feature is too big to explain in a paragraph. What it is, how it works, the build steps, open questions, and how you'll know it works. Add its line to `wiki/index.md`.

## 5. Wireframe anything visual → `<Thing>-Wireframe.html`

A single HTML file showing the screens in their real states (empty, normal, error), with short notes beside each. Use the colours and type from `DESIGN.md`. Review it, change it, and **approve it before any code is written**. Log the approval as a decision. Details: `template/wiki/wireframes.md`.

Wireframes are cheap to change; built screens aren't.

## 6. Build

The agent builds against the spec and the approved wireframe. Status moves to `🔨 In progress` on the roadmap and `CODE WRITTEN` → `BUILT` in `STATUS.md`.

## 7. Test and check

- **Tests:** if this fixes a bug, add a test that would have caught it. A fixed bug leaves a test behind, or it isn't fixed.
- **Checks:** run everything in `CHECKS.md`. Ideally a script does this automatically before every release and refuses to continue if something fails.

## 8. The owner verifies

The person who owns the project tries it, for real, and says it works. Until then it's not done. Write down who checked, on what, and when.

## 9. Release, then record

Ship it. Then flip the roadmap cell (`🚢 Shipped` → `✅ Verified`), update `STATUS.md`, close the ask in `FEEDBACK.md`, and back up.

---

## When something breaks

Real use finds problems a demo never does. Treat each one the same way:

1. **Log it** as an ask in `FEEDBACK.md`, marked as a bug (🐞), with exactly what happened.
2. **Find the cause, not the symptom.** "It works now" is not a diagnosis. Measure: logs, timing, file sizes, the actual data.
3. **Write the cause into the decision** that fixes it, so nobody "simplifies" the fix away later.
4. **Leave a test** that fails without the fix.
5. **Add a line to the hard constraints** if an AI is likely to repeat the mistake, and a line to `CHECKS.md` if it could have been caught before release.

## Checks that run themselves

Every project that ships something grows a list of "things that must still be true": the download link works, analytics is still on every page, the privacy page is still linked, nothing private got published, no forbidden names appear. Keep that list in `CHECKS.md`, then have the AI turn it into a script your publish step runs first. When a check fails, the publish stops and says why.

The rule for adding a check: **you got burned once.** Each line should point at the decision or incident that caused it.

## A note for non-coders

Put this in your hard constraints, in your own words: *"I don't write code. When I need to run something, give me the exact command as a copy-paste block, one step at a time, and wait for me to paste the output back."* It saves more time than any other single line.

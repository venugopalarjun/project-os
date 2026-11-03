# {{PROJECT_NAME}} — Decision Log

**Last updated:** {{YYYY-MM-DD}} ({{D-0XX}} — {{one-line note on the latest entry}})

Newest first. Sequential IDs, never reused, never deleted. A reversed decision gets marked
`superseded by D-0XX` and stays — the record of the reversal is worth more than a clean log.

Format: **Decision** (what) · **Mechanism** (how) · **Why** (reasoning, including what was
rejected) · **Status**.

---

## D-002 · {{YYYY-MM-DD}} · {{Short title that states the decision, not the topic}}

**Decision:** {{What was chosen, in one or two sentences. Be specific enough that someone could act on this alone.}}

**Mechanism:** {{How it actually works — the specific files, settings, sequence, or steps. Skip this if the decision is purely directional.}}

**Why:** {{The reasoning. Critically: what alternatives were considered and why they lost. This is the part future sessions need most, and the part that stops the same debate happening three more times.}}

**Status:** {{PLANNED / CODE WRITTEN / BUILT / TESTED / SHIPPED / LIVE / BLOCKED / PENDING <thing>}} {{YYYY-MM-DD}} — {{what's left, and the exact next action}}

---

## D-001 · {{YYYY-MM-DD}} · {{Short title}}

**Decision:** {{...}}

**Why:** {{...}}

**Status:** {{...}}

---

<!--
GUIDANCE — delete this block once you've written a few real entries.

Title the decision, not the topic.
  Bad:  "D-014 · Database"
  Good: "D-014 · Store everything locally; no server-side user data"

Write "Why" for a stranger. In six months you are a stranger.

Cross-reference by ID. "D-014" is a stable handle you can point at forever, from
STATUS.md, from a wiki page, from a commit message.

Backdate honestly when retrofitting. A decision made in March and logged in July is
dated March, with a note that it was logged late.
-->

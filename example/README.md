# Worked example — "Example Ledger"

A fictional project, filled in, so you can see what these files look like when they're actually being used rather than as blank scaffolds. Names, figures and circumstances are illustrative.

**Example Ledger** is a fictional web app that reconciles bank transactions against invoices for freelance bookkeepers. It's built by one person who doesn't write code, working with AI agents. That combination is deliberate: it's the case where this structure earns the most, because the human can't just read the source to remember what's going on.

Four files are shown:

- **`INDEX.md`** — the front door. Note how short it is, and that it holds no state beyond one sentence.
- **`wiki/index.md`** — the context pack. The priority order and the hard constraints are the parts to study.
- **`STATUS.md`** — note the state vocabulary, the dates, that every `▶ Next up` entry ends with a concrete next action, and that two sections are deliberately empty.
- **`DECISIONS.md`** — an excerpt (4 entries out of 44). Note D-019, written after the mistake that caused it, and D-007, which carries an explicit "don't re-propose this" marker.

The rest of the file set (`VISION`, `ROADMAP`, `ARCHITECTURE`, `FEEDBACK`, `SETUP`, `RECOVERY`) follows the templates directly and isn't reproduced here.

None of these are long. That's the point — the value is in what they *exclude*.

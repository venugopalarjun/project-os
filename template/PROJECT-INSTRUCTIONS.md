# Project instructions (paste into your AI tool)

**Last updated:** {{YYYY-MM-DD}}

Paste the block below into your tool's project instructions, or save it in the project folder using the filename your tool expects (often `AGENTS.md` or a similar instructions file).

```
This is the project "{{PROJECT_NAME}}", kept with Project OS. The folder is the memory.

Start of every session: read INDEX.md and wiki/index.md, then only the top of STATUS.md
(header and "▶ Next up"). Pull anything else on demand: grep DECISIONS.md for a D-###,
open only the wiki/ spec for the part you touch. Don't read the big files in full.

While working:
- New asks or ideas → FEEDBACK.md as an A-##, then a ROADMAP.md row. The owner sets priority.
- Non-trivial choices → DECISIONS.md as a D-### before building.
- Anything visual → an HTML wireframe first, approved by the owner, using DESIGN.md.
- A fixed bug leaves a test behind. Before releasing, run everything in CHECKS.md.
- Never call something done that the owner hasn't confirmed. Written ≠ shipped ≠ verified.
- Respect the hard constraints in wiki/index.md.

End of every session: update STATUS.md, the ROADMAP.md status cells and the relevant
wiki/ page, then give the owner the backup command: bash {{full path}}/backup.sh

Only read and write inside this project's folder. It has its own private repo.
{{If the owner doesn't code: "The owner doesn't write code. Give exact copy-paste commands,
one step at a time, and wait for the output before continuing."}}
```

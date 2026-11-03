# {{PROJECT_NAME}} — project context pack

**Last updated:** {{YYYY-MM-DD}}

Read this first at the start of a session, then drill into the one page you need. The point of this folder is **token economy**: read these distilled pages instead of re-deriving things from source or re-reading the whole of `STATUS.md`. When you change a component or make a decision, update the relevant page here — it's cheap, and it's what keeps this true.

---

## Pages

One line per page, describing what's in it **and its current state**, so an agent can decide what to read without reading it.

- **[{{component-name}}-spec](./{{component-name}}-spec.md)** — {{what this component is and what the page covers}}. **{{Current state: e.g. "Shipped 2026-03-14; follow-up X pending."}}**
- **[{{component-name}}-spec](./{{component-name}}-spec.md)** — {{...}}. **{{...}}**

---

## One-line status

{{The whole project in a few sentences. What exists, where it runs, how it ships. Update whenever it shifts — this is the fastest orientation in the entire folder.}}

---

## Current priority order (set by {{OWNER}})

Strategic sequencing lives in **ROADMAP.md**. This is the near-term tactical order.

1. **{{Priority}}** — {{why it's first, and the immediate next action}}
2. **{{Priority}}** — {{...}}
3. **{{Priority}}** — {{...}}

Later: {{things deliberately deferred, so nobody proposes them as if they're new}}

> This order is set by the human, not the agent. An agent can propose changes to it; it doesn't make them.

---

## Hard constraints (don't forget)

The highest-value list in this folder. Every line is here because something already went wrong once.

- **Update STATUS.md + the relevant wiki page every session.** Whatever you touch or decide, reflect it before you finish. The next session relies on these being current — this is how "check what's next and start" works cold.
- {{CONSTRAINT — something about the owner. E.g. "Owner is not a coder. Whenever they must run anything in a terminal, give the EXACT commands as a copy-paste block (include the `cd`, no placeholders to fill in), one step at a time, and ask for the output back before continuing. Never say 'just build it' or describe steps abstractly."}}
- {{CONSTRAINT — something about the environment. E.g. "Component X compiles only on the owner's machine; the agent's sandbox can't build it. Every change round-trips through them, so reason carefully before handing off a build."}}
- {{CONSTRAINT — something already tried and rejected. E.g. "Library Y can't be used — reason. Don't propose it again. See D-0XX."}}
- {{CONSTRAINT — something that silently breaks. E.g. "Step A must run before step B, never after — reversed, it corrupts data with no clean rollback. Include the cost, not just the prohibition."}}

<!--
How to build this list: ask the owner "what do AI assistants keep getting wrong about
your project?" Their frustrations are the constraints. Add a line every time an agent
gets something wrong in a way that was predictable.
-->

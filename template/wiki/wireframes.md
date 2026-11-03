# Wireframes — how we do them

**Last updated:** {{YYYY-MM-DD}}

**Rule:** anything people will see gets a wireframe before it gets code. The owner approves it, the approval is logged as a decision, then it's built.

## What a wireframe is here

- **One self-contained HTML file** per feature, in the project root: `<Thing>-Wireframe.html` (e.g. `Settings-Export-Wireframe.html`). Opens in any browser; no build step.
- **Real states, not just the happy path:** empty, normal, loading, error, and anything the user can toggle.
- **Real words.** The copy in the wireframe is the copy that ships, so write it properly.
- **Uses `DESIGN.md`** colours, type and components, so the build doesn't have to reinterpret it.
- **Notes beside each frame** (lettered A, B, C) saying what happens on click, what's new, and what's unchanged.

## Asking for one

> Make a wireframe for {{feature}}: show {{states}}. Use DESIGN.md. Put notes beside each frame.

## Versions

Change the same file while you iterate. If you want to keep an older direction, save it as `-v1` / `-v2`. Once approved, record in the decision which file and version was approved.

## After approval

The spec in `wiki/` links to the wireframe. When the feature ships, the wireframe stays as the record of intent; when the screen later changes, update or replace the wireframe first.

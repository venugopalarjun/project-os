# {{PROJECT_NAME}} — Design system

**Last updated:** {{YYYY-MM-DD}}

The single source of truth for how the product looks. Wireframes and code both use these values. If a screen needs something that isn't here, add it here first (and log a decision), then use it.

---

## Principles

1. {{e.g. "Calm and quiet: one accent colour, used sparingly."}}
2. {{e.g. "Plain words over clever ones."}}
3. {{e.g. "Every state is designed: empty, loading, error, done."}}

## Colour tokens

| Token | Light | Dark | Use |
|---|---|---|---|
| `bg` | {{#F3F1EC}} | {{#1C1B19}} | Page background |
| `surface` | {{#FFFFFF}} | {{#262522}} | Cards, panels |
| `ink` | {{#2C2C2A}} | {{#EDEBE6}} | Main text |
| `ink-2` | {{#5F5E5A}} | {{#B7B5AE}} | Secondary text |
| `accent` | {{#D85A30}} | {{#E8774F}} | Primary buttons, key highlights |
| `accent-text` | {{#993C1D}} | {{#F29A78}} | Accent-coloured text (must pass contrast) |
| `success` / `warning` / `danger` | {{…}} | {{…}} | Status only, never decoration |
| `hairline` | {{rgba(0,0,0,.09)}} | {{rgba(255,255,255,.1)}} | Borders, dividers |

Text colours must meet WCAG AA contrast (4.5:1 for body text) on the backgrounds they sit on.

## Type

| Role | Font | Size / weight |
|---|---|---|
| Display | {{serif or brand face}} | {{40–56 px, regular}} |
| Heading | {{…}} | {{20–28 px}} |
| Body | {{system sans}} | {{14–16 px, line-height 1.5}} |
| Label / kicker | {{…}} | {{11 px, semibold, uppercase, letter-spacing .08em}} |

{{Weight rules, e.g. "semibold, never bold."}}

## Spacing, radius, elevation

- Spacing scale: {{4 · 8 · 12 · 16 · 24 · 32 · 48}}
- Radius: {{buttons 8 · cards 12 · pills 999}}
- Shadows: {{when to use, and the one or two values allowed}}

## Components

For each: what it's for, its states, and the tokens it uses.

- **Button** — primary (accent fill), secondary (outline), quiet (text). States: default, hover, pressed, disabled, focus (2 px accent ring).
- **Card** — {{…}}
- **Pill / chip** — {{…}}
- **{{Component}}** — {{…}}

## Writing

- {{Voice: e.g. "Talk like a helpful colleague, not a brand."}}
- {{Buttons say what happens: "Publish", then a toast "Published".}}
- {{Words to avoid.}}

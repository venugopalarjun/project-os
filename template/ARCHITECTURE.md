# {{PROJECT_NAME}} — Architecture

**Last updated:** {{YYYY-MM-DD}}

How it's built, and why those choices. Component detail lives in `wiki/`; this is the map.

## The shape of it

{{A paragraph, or an ASCII diagram, showing the pieces and how data moves between them.
Someone should be able to read this and know where a given piece of logic lives.}}

```
{{input}} → {{component}} → {{component}} → {{output}}
                  ↓
            {{side channel}}
```

## Components

| Piece | Does what | Lives in | Spec |
|---|---|---|---|
| {{name}} | {{one line}} | `{{path}}` | [{{spec}}](wiki/{{spec}}.md) |
| {{name}} | {{one line}} | `{{path}}` | — |

## Stack choices

| Choice | Picked | Over | Because |
|---|---|---|---|
| {{Layer}} | {{what}} | {{alternatives}} | {{reason}} ({{D-0XX}}) |
| {{Layer}} | {{what}} | {{alternatives}} | {{reason}} |

## Where things live

- `{{path}}/` — {{what's in it}}
- `{{path}}/` — {{what's in it}}

## Constraints this imposes

{{The consequences of the above that will bite someone later. Things that can't be changed
easily, things that have to happen in a particular order, things that only work on one machine.}}

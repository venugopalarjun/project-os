# {{PROJECT_NAME}} — Checks

**Last updated:** {{YYYY-MM-DD}}

What must be true before anything ships. Each line is here because something broke once. Keep it short, specific and checkable, and point each line at the decision or incident behind it.

Once there are more than a handful, ask your AI tool to turn this list into a script (e.g. `checks.sh` or `verify.py`) that your release or publish step runs first, and that stops the release when a check fails. Then nobody has to remember the list.

**How to run them:** `{{command, e.g. bash checks.sh}}`
**Runs automatically:** {{yes — in publish.sh, before pushing / no, manual}}

---

## Release

- [ ] Version number bumped before building ({{D-0XX}})
- [ ] All tests pass
- [ ] The download / install link works on a clean machine

## Website or public pages (if any)

- [ ] Every page links the privacy policy and terms
- [ ] Analytics is on every page, and the key buttons are still tracked
- [ ] Structured data matches the visible text (e.g. FAQ markup = visible FAQ)
- [ ] Every internal link goes to a real page
- [ ] No prototype or placeholder text published

## Privacy and safety

- [ ] No secrets, tokens or private data in anything published
- [ ] {{Names, companies or data that must never appear publicly}}
- [ ] {{Anything a third party's terms require, e.g. a platform's data policy}}

## Project-specific

- [ ] {{The thing that broke last time}} ({{D-0XX}})

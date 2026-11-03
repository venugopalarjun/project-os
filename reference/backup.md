# Backup — because the folder is the memory

If you take the core principle seriously — *the folder is the memory* — then a folder that exists in exactly one place on one laptop isn't memory. It's a single point of failure holding every decision, every spec, and the entire reasoning history of the project.

The code usually survives elsewhere — in a repo, in a deploy, in someone's fork. The reasoning doesn't.

This page is the strategy. `template/backup.sh` is the script. `template/RECOVERY.md` is what you read on a new machine when the old one is gone.

---

## The three things people get wrong

**1. Assuming it's already backed up.** The most common version: the project has a public repo for the shipped artifact, and everyone assumes that's the backup. It isn't — public repos usually contain a curated subset, and the docs folder is rarely in it. Check before assuming. The question to answer precisely is: *"if this laptop died right now, which specific files would be gone?"*

**2. Backing up to a public repo.** `DECISIONS.md` contains strategy and what you rejected. `ROADMAP.md` contains unshipped plans. `FEEDBACK.md` contains real users saying real things, often identifiably. `wiki/index.md` contains your constraints, which are a map of where the project is weak. None of that belongs on a public repo. **Use a private one.**

**3. Backing up everything.** Sweeping in build output, models, dependency trees, and logs turns a 3 MB backup into a 20 GB one that's slow, expensive, and fails silently. Worse, it's how secrets get committed.

---

## What goes in, and what doesn't

The test is: **would I have to re-derive this, or can a command regenerate it?**

| Back it up | Leave it out | Because |
|---|---|---|
| All the Project OS markdown files | Build output, compiled artifacts | A build command regenerates them |
| `wiki/` — every component spec | Dependency dirs (`node_modules`, `.venv`, `vendor`) | A package manager regenerates them |
| Source you wrote | Downloaded models, large binaries | Re-downloadable, and they'll blow your size limit |
| Build and release scripts | Runtime logs, caches, temp files | No value once the moment passed |
| Config templates and examples | Secrets, tokens, keys, `.env` | **Never.** These get recreated, not recovered |
| Design assets, wireframes | Anything genuinely private | See below |

### The private-data question

Some projects hold data that shouldn't leave the machine even to a private repo — user recordings, customer records, personal notes, anything covered by a promise you made.

If your project has this, exclude it deliberately and **write down that you did**. The failure mode is someone assuming a full restore is possible when it isn't. `RECOVERY.md` should say plainly: *"X is not in the backup, on purpose. If it matters, it needs a disk-level backup. Git will not save it."*

This is a privacy decision, not a size decision, and it should be recorded in `DECISIONS.md` as one.

---

## Guards: the script should refuse to push

A backup script that pushes whatever it's given will eventually push a token. Make it refuse, loudly, naming the file. `template/backup.sh` blocks on:

| Guard | Catches | Reliable? |
|---|---|---|
| **Credential files** | `.env`, `*.pem`, `*.key`, ssh keys staged by accident | Yes |
| **Secret patterns** | GitHub / Stripe / AWS / Google / Slack / GitLab tokens, private-key blocks, `API_KEY=`-style assignments | Pattern-based, so not exhaustive |
| **File size cap** | A build artifact or model that slipped past `.gitignore` | Yes |
| **Private paths** | Anything under directories you listed | Yes |
| **Forbidden remote** | A remote you explicitly named, e.g. your public repo | Yes, if you configure it |
| **Public remote** | The remote being public | **Only with the GitHub CLI installed and authenticated.** Otherwise it warns and proceeds — see below |

Three things it deliberately does *not* do, which you must handle at setup:

- It can't detect a blanket-ignore whitelist. That's the manual check below.
- It can't prove a remote is private without `gh`. Install and authenticate the GitHub CLI, or verify by hand once and use `FORBIDDEN_REMOTE` to block the alternative.
- Pattern matching will never catch every secret. It reduces accidents; it isn't a control you should rely on.

A refusal is the script working. It should say so, in those words — otherwise the first refusal reads as a breakage and someone disables the guard.

### Two failure modes worth knowing about

**A commit that was made but never pushed.** If the network drops between commit and push, a naive script reports "nothing has changed, you're safe" on every subsequent run — while the work sits local-only. The bundled script compares `HEAD` against the upstream and retries. If you write your own, do the same.

**A log that only ever says "no changes."** Check `backup.log` against the remote occasionally rather than trusting it alone.

---

## Two traps that hide entire directories

Both of these produce a backup that *looks* complete and isn't. Check for them once, at setup.

### Nested git repositories

If a subdirectory has its own `.git` and isn't registered as a submodule, `git add -A` records a bare pointer and **silently skips every file inside it**. The parent repo shows a single entry; the contents are nowhere. You find out during recovery.

Find them:

```bash
find . -name .git -mindepth 2 -not -path './.git/*'
```

Anything that turns up is either a proper submodule or a directory you should remove the inner `.git` from. Decide deliberately.

### Blanket-ignore whitelists

A `.gitignore` that reads `*` followed by a few `!allowed-file` lines is a whitelist. They're legitimate — often protecting a public-facing directory — but they also hide everything not on the list from *any* git operation, including your backup.

The bad case: a whitelist protecting a publish directory also hides the publish scripts. Lose the laptop and you lose the ability to ship, which is a worse outcome than losing the code.

Fix by force-adding the specific files to the private backup rather than weakening the whitelist:

```bash
git add -f path/to/release-script.sh path/to/publish-docs.md
```

Both traps are worth a line in your hard-constraints list once found.

---

## Cadence

**Both, not either:**

- **Manual, end of session.** Same moment as updating `STATUS.md` — the two belong together. You've just written down what happened; push it.
- **Scheduled nightly.** The safety net. Worst case becomes one lost day instead of everything since you last remembered.

Set the scheduled job up with your OS's own scheduler — `launchd` on macOS, `cron` or a systemd timer on Linux, Task Scheduler on Windows. Not with an AI assistant's task feature: those usually run in a sandbox that can't reach your credential store or your local filesystem the way a native job can.

Have the script append to a log, and check it occasionally against what's actually on the remote. A backup that has been silently failing for three weeks is worse than no backup, because you thought you were covered.

This is not hypothetical. The project this template came from lost two days of backups to a stale `.git/index.lock`: `git add` failed, the script carried on, found nothing staged, and reported *"Nothing has changed since the last backup. You're already safe."* Every run said that until someone read the output properly. Hence two rules the bundled script now follows: **a failing `git add` is fatal**, and **when nothing is staged it checks for unpushed commits** (`@{upstream}..HEAD`) rather than assuming silence means safety.

---

## If you edit the script: it targets bash 3.2

macOS still ships **bash 3.2** (2007) as `/bin/bash`, and `#!/usr/bin/env bash` finds it unless the user installed a newer one. So "works on macOS" means "works on 3.2", which rules out a surprising amount:

- no `mapfile` / `readarray` — read NUL-delimited paths with `while IFS= read -r -d '' f; do … done < <(git … -z)` instead
- no associative arrays (`declare -A`), no `${var,,}` / `${var^^}`, no `local -n`, no `**` globstar
- **an empty array counts as unset**, so under `set -u` never expand `"${arr[@]}"` or `${#arr[@]}` bare — use `${arr+"${arr[@]}"}`, or track a plain counter

The trap here is that the script will look fine on your machine if you have a modern bash from Homebrew, and fail on the first line of array handling for everyone else.

---

## Credentials

Never in the repo. Never in `git config`. Read them at push time from the OS credential store:

- macOS: `security find-generic-password -a "$USER" -s "<name>" -w`
- Linux: `secret-tool lookup service <name>`
- Windows: Credential Manager, or Git Credential Manager

Pass it to git through `GIT_ASKPASS`, not by embedding it in the remote URL. A token in the URL ends up in the process table (visible to `ps` for the duration of the push) and in git's own error text, which is how it reaches your terminal and your logs.

The bundled script writes the token to a `0600` file inside a `0700` `mktemp -d` directory, removed by an `EXIT` trap, and scrubs `https://user@` patterns out of any error it prints. That's the minimum. If you write your own, match it.

---

## Writing RECOVERY.md

Write it as though you have a new machine, a GitHub login, and nothing else. That framing catches the omissions — the tool you forgot you'd installed, the token you forgot existed, the config file that was never in the repo.

It needs:

1. **What's in the backup and what isn't**, as a table, including where each excluded thing comes from instead
2. **Numbered recovery steps**, one command each, in order, with what success looks like
3. **The credentials to recreate**, and where to get each one
4. **A verification step** — how to know recovery actually worked
5. **First-time setup**, kept for the case where the repo itself needs rebuilding

Then do the honest thing and read it once from the top, pretending you know nothing. Most `RECOVERY.md` files have at least one step that only works because of something already sitting on the author's machine.

Best of all: actually test a restore once, into a private scratch directory — `mktemp -d`, not a world-readable `/tmp/something` path, since the clone contains everything you just decided shouldn't be public. Delete it afterwards.

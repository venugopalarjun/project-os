# Recovery — getting {{PROJECT_NAME}} back after losing this machine

**Last updated:** {{YYYY-MM-DD}}

> This is the document you read on a brand-new machine when the old one is gone.
> It assumes you have nothing but a login to {{where the backup lives}}.
> Follow it top to bottom, one command at a time.

---

## What is and isn't in the backup

The private repo (`{{owner/repo}}`) holds **{{~N files, ~N MB}}**: the docs, specs, decision log, and source. It deliberately excludes anything large, regenerable, secret, or private — the table below is the authoritative list.

| In the backup ✅ | Not in the backup ❌ | Where the excluded thing comes from instead |
|---|---|---|
| All Project OS docs (INDEX, STATUS, ROADMAP, DECISIONS, VISION, ARCHITECTURE, FEEDBACK, SETUP, this file) | {{build output dir}} | Rebuilt by `{{build command}}` |
| `wiki/` — all component specs | {{dependency dir}} | Reinstalled by `{{install command}}` |
| Source you wrote | {{large assets / models}} | Re-downloaded from {{where}} |
| Build + release scripts | {{logs, caches, temp}} | No value once the moment passed |
| Config templates | Secrets and tokens | Recreated, not recovered — see step {{N}} |
| {{...}} | {{genuinely private data, if any}} | **{{Only source: your disk-level backup. Not recoverable from the repo, by design.}}** |

{{If the project holds data that deliberately never leaves the machine, say so
here, in plain words, and say what the only real source is. The failure mode is
someone assuming a full restore is possible when it isn't.}}

---

## Recovery, step by step

Run these **one at a time**. If anything looks wrong, stop and check before continuing.

### 1. Install the basics

```
{{exact command — e.g. installing git and the language toolchain}}
```

Expected: {{what success looks like}}

### 2. Clone the private repo

```
{{exact clone command, including --recurse-submodules if you use submodules}}
```

{{If you use submodules, note it here — forgetting the flag produces empty
directories that look like a corrupted clone. The fix:}}

```
cd {{project path}} && git submodule update --init --recursive
```

### 3. Restore dependencies

```
{{exact command}}
```

Expected: {{...}}

### 4. Build / run

```
{{exact command}}
```

Expected: {{...}}

### 5. Recreate the credentials

None of these are in the repo. All are recreated, not recovered.

**{{Credential name}}** — needed for {{what}}. Create at {{where}}, then store it:

```
{{exact command to put it in the OS credential store}}
```

**{{Credential name}}** — {{...}}

### 6. Restore local-only config

{{Any file that's deliberately not in the repo — personal settings, a local
config with real names in it. Say how to rebuild it from the template that IS
in the repo.}}

### 7. Verify the backup loop still works

```
bash {{project path}}/backup.sh --dry-run
```

Expected on a fresh clone: `Nothing has changed since the last backup, and nothing is unpushed.` That's the correct result — there's genuinely nothing new yet. To see the guards actually run, change a file first.

---

## First-time setup

*(Already done on the original machine. Kept here for the case where the backup repo itself has to be recreated.)*

1. Create an **empty private** repo named `{{repo-name}}`. No README, no `.gitignore`, no licence — they'll conflict with what's already here.

2. Initialise and point at it:

```
cd {{project path}} && git init -b main
```

```
cd {{project path}} && git remote add origin {{remote url}}
```

3. Open `backup.sh` and fill in all five items in the CONFIGURE block at the top — private paths, size cap, forbidden remotes, FORCE_ADD, and the token source. Fill in its `Last updated` line too.

4. Dry-run first, then push for real:

```
cd {{project path}} && bash backup.sh --dry-run
```

```
cd {{project path}} && bash backup.sh
```

---

## Routine backups

| How | What it does |
|---|---|
| `bash {{project path}}/backup.sh` | Run at the end of a working session, alongside updating STATUS.md. Checks for secrets, private data, and oversized files, then commits and pushes. |
| Nightly scheduled job | Safety net, so the worst case is losing one day. Set up with {{launchd / cron / Task Scheduler}} — not with an AI assistant's scheduler, which usually can't reach your credential store. |
| `git log origin/main -1` | The honest check. Compares what's actually on the remote against what you think you pushed. |
| `bash {{project path}}/backup.sh --dry-run` | Shows what would be sent, pushes nothing. |

`backup.sh` **refuses to push** — loudly, naming the file — if it finds a credential file, a secret pattern, a file over the size cap, anything under a private path, or a remote you listed as forbidden. It can only verify that a remote is *private* when the GitHub CLI is installed and authenticated; otherwise it warns and proceeds. A refusal is the script working.

Check `backup.log` occasionally, against what's actually on the remote — the log alone can look healthy while nothing has been pushed. Note that `backup.log` is gitignored, so it does not survive into a recovered clone; it's a local signal, not a record.

---

## Test this once

Clone the repo into a **private** scratch directory and follow the steps above from a cold start. Not a predictable `/tmp/name` path — the clone contains everything you just decided shouldn't be public, and `/tmp` is world-readable.

```
D=$(mktemp -d) && git clone {{remote url}} "$D/recovery-test" && cd "$D/recovery-test"
```

Delete it when you're done: `rm -rf "$D"`.

Almost nobody does this, and the ones who do usually find at least one step that only worked because of something already sitting on the original machine.

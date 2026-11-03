# Getting started

**Last updated:** 2026-11-03

Written for people who don't code. Every command is something you copy and paste. If anything prints an error, paste it back to your AI tool and ask what it means before going on.

You need about 30 minutes for the setup, once.

---

## What you need

- A computer with a folder for your project (an empty one is fine).
- An AI tool that can read and write files in that folder. This might be an AI-enabled editor, desktop app, or coding assistant. Plain chat without file access works too, but you'll copy text in and out by hand.
- A free GitHub account, for the backup. github.com/signup
- `git`. On a Mac, open Terminal and run `git --version`. If it asks to install the developer tools, say yes.

---

## Step 1 — Download Project OS

On this repo's GitHub page, click **Code → Download ZIP** and unzip it. You only need two files from it for a new project:

- `starter-kit/PROJECT-OS-STARTER.md`
- `starter-kit/backup.sh`

Copy both into your project folder.

*(If your AI tool supports skills or reusable instructions, you can also install the optional skill at the end.)*

## Step 2 — Let the AI set up the files

Open your project folder in your AI tool and say:

> Set up this project using PROJECT-OS-STARTER.md.

It will ask you a few questions: the project's name, what it is in one sentence, your top three priorities right now, whether you write code, and the things AI tools keep getting wrong about your project. Answer honestly and briefly. That last question becomes your **hard constraints** list, the most useful part of the whole system.

When it's done you'll have `INDEX.md`, `wiki/index.md`, `STATUS.md`, `ROADMAP.md`, `DECISIONS.md`, `FEEDBACK.md` and the rest, filled in with what you said. Anything it didn't know is marked "TBD".

**Check two things yourself:** the priority order in `wiki/index.md`, and the hard constraints. Those are yours to own. Fix them if they're wrong.

## Step 3 — Tell your AI tool the rules, permanently

Open `template/PROJECT-INSTRUCTIONS.md` from the download, fill in your project name and folder, and paste it into your tool's project instructions:

- Use your tool's project-instructions area, if it has one.
- Otherwise, save it in the project folder using the filename your tool expects (often `AGENTS.md` or a similar instructions file).

This is what makes every new session start by reading the right two files instead of everything.

## Step 4 — Create a private GitHub repo

1. On GitHub, click **+ → New repository**.
2. Name it after your project. Choose **Private**. Don't add a README.
3. Click **Create repository** and copy the URL that ends in `.git`.

**Private, not public.** Your decision log is your strategy, your roadmap is unreleased, and your feedback file quotes real people.

## Step 5 — Give the backup a GitHub token

The backup script needs permission to push to that repo. In GitHub:

1. Go to **github.com/settings/tokens → Generate new token → Generate new token (classic)**.
2. Name it "project backup". Tick **repo** and **workflow**.
   *Tick workflow even if you don't think you need it: the day an AI adds an automatic check to your repo, a token without it gets rejected.*
3. Click **Generate token** and copy it.

Store it safely. On a Mac, run this in Terminal and paste the token when asked (it won't show as you paste):

```
security add-generic-password -U -a "$USER" -s "project-github-token" -w
```

If you name it differently, put the same name in the next step.

## Step 6 — Connect and test the backup

In Terminal, go to your project folder and connect it to the repo (replace the path and URL with yours):

```
cd ~/path/to/your/project
git init
git remote add origin https://github.com/YOUR-NAME/YOUR-REPO.git
git remote -v
```

The last line should show your private repo twice. Then open `backup.sh`, find the **CONFIGURE** block at the top, and fill in its five items. For item 5, if you stored the token as in Step 5, use:

```
TOKEN_COMMAND='security find-generic-password -a "$USER" -s project-github-token -w'
```

If unsure, ask your AI tool: *"Help me fill in the CONFIGURE block in backup.sh."* Then test it without pushing:

```
bash backup.sh --dry-run
```

If that looks right, run it for real:

```
bash backup.sh
```

It should end with "Pushed to GitHub". If it stops, it tells you why: a file that looks like a password or key, a file that's too big, or a remote that looks public. That's the script doing its job.

## Step 7 — Use it

**Start every session with:**

> Read INDEX.md and wiki/index.md, then pick up the top item.

**When you have a new idea or someone asks for something:**

> Log this in FEEDBACK.md and add it to the roadmap: …

**When you make a choice:**

> Log this as a decision: …

**For anything people will see:**

> Show me a wireframe first.

**End every session with:**

> Update STATUS, the roadmap and the wiki, then give me the backup command.

That last one is the habit everything depends on. If a session ends without it, the next one starts confused.

## Step 8 — Add checks once you ship something

The first time you put something in front of other people (an app, a website, a document set), start a `CHECKS.md` from `template/CHECKS.md`. Each time something breaks in a way you could have caught, add a line. Then ask your AI tool to turn the list into a script that runs every time you publish, so you never have to remember it. See `reference/workflow.md`.

---

## When things go wrong

| You see | What it means | What to do |
|---|---|---|
| `refusing to allow a Personal Access Token to create or update workflow` | Your token is missing the **workflow** permission. | Make a new token with **repo** and **workflow** (Step 5), store it again, rerun the backup. |
| `Permission denied` or `Authentication failed` | The token expired or is wrong. | Make a new token, store it again. |
| The backup says "nothing to back up" but you changed files | A folder inside your project has its own `.git`, so its files are skipped. | Ask your AI tool: *"Check for nested git repos in this folder."* |
| The AI re-proposes something you already rejected | It's not in the constraints list. | Add one line to the hard constraints in `wiki/index.md`, with the reason. |
| A new session starts by asking what the project is | `STATUS.md` or `wiki/index.md` is out of date. | Update them now; this is rule 1. |
| `STATUS.md` or `DECISIONS.md` is huge and slow | Logs grow forever. | Ask: *"Compact STATUS.md using reference/compaction.md."* |

## Optional: install the skill

The skill lets a compatible AI tool set up new projects, retrofit old ones, log decisions and compact logs on request.

Keep the included `SKILL.md` with the rest of the download, then follow your AI tool's instructions for adding a local skill or reusable project template. In any project, you can say *"set up Project OS"* or *"retrofit Project OS onto this folder."*

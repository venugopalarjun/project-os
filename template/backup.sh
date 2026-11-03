#!/usr/bin/env bash
#
# backup.sh — push this project to its PRIVATE git remote.
#
# Part of Project OS. The premise is that this folder is the project's memory,
# so a copy that exists only on this machine isn't a backup of anything.
#
# Usage:
#   bash backup.sh              commit + push
#   bash backup.sh --dry-run    run every check, show what would go, push nothing
#
# The script REFUSES to push if it finds a secret, an oversized file, or
# anything under a path you marked private. A refusal is the script working,
# not breaking — it names the file.
#
# Works on macOS and Linux. Requires bash and git. If the GitHub CLI (`gh`) is
# installed and authenticated it also verifies the remote repo is private;
# without it, that check degrades to a warning — see reference/backup.md.
#
# Last updated: {{YYYY-MM-DD}}   <- fill this in, like every other file here

set -uo pipefail

# ── bash 3.2 constraint (read this before editing) ──────────────────────────
# macOS still ships bash **3.2** (2007), and `/usr/bin/env bash` finds it unless
# the user installed a newer one — so "works on macOS" means "works on 3.2".
# Keep to 3.2 syntax: no `mapfile`/`readarray`, no associative arrays
# (`declare -A`), no `${var,,}` / `${var^^}`, no `local -n`, no `**` globstar.
# Also, 3.2 treats an EMPTY array as unset, so under `set -u` never expand
# `"${arr[@]}"` or `${#arr[@]}` bare — use `${arr+"${arr[@]}"}` (as below) or
# track a separate counter.
if [ -z "${BASH_VERSION:-}" ]; then
  echo "This script needs bash (run it as: bash backup.sh)." >&2
  exit 1
fi

# ─── CONFIGURE THIS BLOCK ───────────────────────────────────────────────────

# 1. Paths that must NEVER be pushed. Extended regex, matched against paths
#    relative to the project root. Add anything private. Set to a pattern that
#    matches nothing if none applies.
PRIVATE_PATHS='^(secrets|private|customer-data)/'

# 2. Largest file allowed, in KB. Bigger is nearly always a build artifact,
#    model, or media file that escaped .gitignore.
MAX_FILE_KB=5120

# 3. Remotes to refuse outright — typically your PUBLIC repo, so a mistyped
#    remote can't leak internal docs. Extended regex.
FORBIDDEN_REMOTE='NOTHING_MATCHES_THIS'

# 4. Files hidden by a blanket-ignore whitelist that you still want backed up.
#    See reference/backup.md, "Blanket-ignore whitelists". One path per line.
#    The script FAILS if a listed path is missing — that's the point of it.
FORCE_ADD=(
  # "publish/release.sh"
  # "publish/PUBLISHING.md"
)

# 5. Command that prints your push token to stdout, if you use HTTPS + a token.
#    macOS:   security find-generic-password -a "$USER" -s NAME -w
#    e.g.     TOKEN_COMMAND='security find-generic-password -a "$USER" -s project-github-token -w'
#    The token needs the 'repo' and 'workflow' scopes (classic token).
#    Linux:   secret-tool lookup service NAME
#    Leave empty to rely on SSH keys or git's own credential helper.
#    (GIT_PUSH_TOKEN in the environment overrides this.)
TOKEN_COMMAND=""

# ─── END CONFIGURATION ──────────────────────────────────────────────────────

PROJECT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$PROJECT/backup.log"

DRY_RUN=0
case "${1:-}" in
  "")          ;;
  "--dry-run") DRY_RUN=1 ;;
  *) printf 'Unknown option: %s\nUsage: bash backup.sh [--dry-run]\n' "$1" >&2; exit 2 ;;
esac

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }
die()  { printf '\n\033[31mSTOPPED — nothing was pushed.\033[0m\n%s\n\n' "$1" >&2
         printf 'Nothing is broken. Fix what is named above, then run this again.\n' >&2
         [ "${STAGED_BY_US:-0}" = 1 ] && git reset -q 2>/dev/null
         exit 1; }

# Everything sensitive lives in one 0700 temp dir, removed on any exit.
TMPDIR_RUN="$(mktemp -d)"; chmod 700 "$TMPDIR_RUN"
cleanup() { rm -rf "$TMPDIR_RUN"; }
trap cleanup EXIT INT TERM

# portable file size in bytes; prints nothing and fails if it can't tell
filesize() { stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null; }

echo
echo "Backup — $(date '+%A %d %B %Y, %H:%M')"
echo "──────────────────────────────────────────────"
[ "$DRY_RUN" = 1 ] && echo "DRY RUN — every check runs, nothing is pushed." && echo

cd "$PROJECT" || die "Can't find the project directory."

# ── 0. is this a git repo? (.git is a FILE in worktrees and submodules) ─────
git rev-parse --git-dir >/dev/null 2>&1 || die "This folder isn't a git repo yet.
Run the one-time setup in RECOVERY.md → 'First-time setup' first."

# ── 1. the index must be clean, or our reset would destroy the user's work ──
if ! git diff --cached --quiet 2>/dev/null; then
  die "You already have files staged. This script stages everything itself and
resets the index if a check fails, which would throw away that staging.
Commit or unstage first:
    git commit        (keep it)
    git reset         (discard the staging, keep the files)"
fi

# ── 2. remote sanity ────────────────────────────────────────────────────────
REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"

if [ -z "$REMOTE_URL" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    warn "No 'origin' remote yet — checking files anyway, since this is a dry run"
  else
    die "No 'origin' remote is set, so there's nowhere to push.
See RECOVERY.md → 'First-time setup'."
  fi
fi

if [ -n "$REMOTE_URL" ] && echo "$REMOTE_URL" | grep -qE "$FORBIDDEN_REMOTE"; then
  die "DANGER: 'origin' points at a remote you marked as forbidden:
    $REMOTE_URL
This project's docs must not go there."
fi

# Best-effort privacy check. This is NOT a guarantee: it only works with the
# GitHub CLI installed, authenticated, against a GitHub HTTPS/SSH remote.
if [ -n "$REMOTE_URL" ]; then
  VIS=""
  command -v gh >/dev/null 2>&1 && \
    VIS="$(gh repo view "$REMOTE_URL" --json visibility -q .visibility 2>/dev/null || true)"
  case "$VIS" in
    PUBLIC) die "DANGER: the remote repo is PUBLIC:
    $REMOTE_URL
DECISIONS.md, ROADMAP.md and FEEDBACK.md are not public material.
Make the repo private, or point origin somewhere else." ;;
    PRIVATE|INTERNAL) ok "Remote is $VIS: $REMOTE_URL" ;;
    *) warn "Could NOT verify this remote is private — you must check yourself:"
       echo "      $REMOTE_URL"
       echo "      (install + authenticate the GitHub CLI to automate this check)" ;;
  esac
fi

# ── 3. stage ────────────────────────────────────────────────────────────────
# Stale index.lock recovery, first. git leaves .git/index.lock behind whenever an
# operation is interrupted — an editor's git integration, a closed terminal, a
# machine that slept — and every later run then fails to stage. In the project
# this template came from that stranded two separate backups. Removing the lock is
# safe ONLY if nothing could still own it, so both must hold: no git process
# running, and the lock older than two minutes. Otherwise refuse: deleting a live
# lock can corrupt the index.
LOCK="$PROJECT/.git/index.lock"
if [ -f "$LOCK" ]; then
  lock_mtime="$(stat -f%m "$LOCK" 2>/dev/null || stat -c%Y "$LOCK" 2>/dev/null || echo 0)"
  lock_age=$(( $(date +%s) - lock_mtime ))
  if pgrep -x git >/dev/null 2>&1 || pgrep -f 'git-remote' >/dev/null 2>&1; then
    die "A git process is running right now and owns $LOCK.
Wait for it to finish, then run this again. (Nothing has been backed up.)"
  elif [ "$lock_age" -lt 120 ]; then
    die "$LOCK was created ${lock_age}s ago — something may be mid-operation.
Wait a minute and run this again. (Nothing has been backed up.)"
  else
    warn "Removing a stale .git/index.lock (${lock_age}s old, no git process running)"
    rm -f "$LOCK"
    echo "$(date '+%F %H:%M')  removed stale index.lock (${lock_age}s old)" >> "$LOG"
  fi
fi

# From here a refusal unstages again (see die()), leaving the tree as found.
STAGED_BY_US=1

# If `git add` fails we must STOP. Unchecked, the run reports "nothing has
# changed" and exits 0 — a backup that says you're safe when nothing was saved
# is worse than no backup. Most common cause: a nested repo with no commit.
if ! ADD_ERR="$(git add -A 2>&1)"; then
  die "Staging failed, so NOTHING has been backed up:
$(echo "$ADD_ERR" | sed 's/^/    /')
If that mentions a directory that 'does not have a commit checked out', it is a
nested git repo. Make it a submodule or remove its inner .git — until then its
contents are not in this backup."
fi

# Force-add files hidden by a whitelist .gitignore. A missing one is an error:
# silently dropping it is exactly the failure this feature exists to prevent.
for f in ${FORCE_ADD+"${FORCE_ADD[@]}"}; do
  [ -e "$f" ] || die "FORCE_ADD lists a path that doesn't exist: $f
It was probably renamed or deleted. Update FORCE_ADD at the top of this script."
  git add -f -- "$f" || die "Couldn't force-add $f"
done

# Read staged paths NUL-delimited: -z bypasses core.quotePath escaping, which
# would otherwise hide any path containing a non-ASCII byte from every guard.
#
# Done with `read -r -d ''` rather than `mapfile -d ''` because **mapfile does not
# exist in bash 3.2**, which is the bash macOS still ships — and `/usr/bin/env
# bash` finds it unless the user installed a newer one. A separate counter is kept
# instead of `${#STAGED[@]}` because bash 3.2 treats an empty array as *unset*, so
# under `set -u` that expansion can abort the script. See the note at the top.
STAGED=()
STAGED_N=0
while IFS= read -r -d '' f; do
  STAGED+=("$f")
  STAGED_N=$((STAGED_N + 1))
done < <(git diff --cached --name-only -z --diff-filter=ACMR)

if [ "$STAGED_N" -eq 0 ]; then
  # Nothing new — but an earlier run may have committed and failed to push.
  # Without this, an unpushed backlog is reported as "safe" every night.
  UNPUSHED=0
  if [ -n "$REMOTE_URL" ]; then
    UP="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
    if [ -n "$UP" ]; then
      UNPUSHED="$(git rev-list --count "${UP}..HEAD" 2>/dev/null || echo 0)"
    else
      UNPUSHED="$(git rev-list --count HEAD 2>/dev/null || echo 0)"
    fi
  fi
  if [ "$UNPUSHED" -gt 0 ] && [ "$DRY_RUN" = 0 ]; then
    warn "$UNPUSHED local commit(s) have never reached the remote — pushing those now"
  else
    echo
    ok "Nothing has changed since the last backup, and nothing is unpushed."
    echo "$(date '+%F %H:%M')  no changes" >> "$LOG"
    exit 0
  fi
fi
COUNT="$STAGED_N"
[ "$COUNT" -gt 0 ] && ok "$COUNT file(s) changed since last backup"

# ── 4. GUARD: private paths ─────────────────────────────────────────────────
LEAK=""
for f in ${STAGED+"${STAGED[@]}"}; do
  echo "$f" | grep -qE "$PRIVATE_PATHS" && LEAK="$LEAK
    $f"
done
[ -n "$LEAK" ] && die "Files under a path you marked private are staged:$LEAK
Your .gitignore should be excluding these. Don't push until it does."
[ "$COUNT" -gt 0 ] && ok "No private-path files staged"

# ── 5. GUARD: secrets ───────────────────────────────────────────────────────
# Guards read the INDEX (git show ":path"), not the working tree — a file that
# was staged and then edited must be judged as staged.
SECRET_RE='(ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|(sk|rk)_(live|test)_[A-Za-z0-9]{16,}|hf_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|glpat-[A-Za-z0-9_-]{15,}|-----BEGIN [A-Z ]*PRIVATE KEY|(API_?KEY|SECRET_?KEY|ACCESS_?TOKEN|PASSWORD)[[:space:]]*[=:][[:space:]]*[A-Za-z0-9/+_-]{12,})'
FOUND=""; ENVFILES=""
for f in ${STAGED+"${STAGED[@]}"}; do
  case "$f" in
    *.png|*.jpg|*.jpeg|*.gif|*.ico|*.webp|*.pdf|*.zip|*.gz|*.bin|*.woff|*.woff2) continue ;;
  esac
  case "$(basename "$f")" in
    .env|.env.*|*.pem|*.key|*.p12|id_rsa|id_ed25519) ENVFILES="$ENVFILES
    $f" ; continue ;;
  esac
  blob="$(git show ":$f" 2>/dev/null)" || continue
  hit="$(printf '%s' "$blob" | grep -InE "$SECRET_RE" 2>/dev/null | head -2 || true)"
  [ -n "$hit" ] && FOUND="$FOUND
    $f
$(echo "$hit" | cut -c1-120 | sed 's/^/      /')"
done
[ -n "$ENVFILES" ] && die "Credential files are staged and must never be committed:$ENVFILES
Add them to .gitignore. Keep the values in your OS credential store."
[ -n "$FOUND" ] && die "Something that looks like a live key or token is staged:$FOUND
Move it to your OS credential store, remove it from the file, then run again."
[ "$COUNT" -gt 0 ] && ok "No credential files or tokens staged"

# ── 6. GUARD: oversized files ───────────────────────────────────────────────
BIG=""; UNKNOWN=""
for f in ${STAGED+"${STAGED[@]}"}; do
  bytes="$(git cat-file -s ":$f" 2>/dev/null)" || bytes=""
  if [ -z "$bytes" ]; then
    if [ -f "$f" ]; then bytes="$(filesize "$f" || true)"; fi
  fi
  if [ -z "$bytes" ]; then UNKNOWN="$UNKNOWN
    $f" ; continue ; fi
  kb=$(( bytes / 1024 ))
  [ "$kb" -gt "$MAX_FILE_KB" ] && BIG="$BIG
    $f  (${kb} KB)"
done
[ -n "$UNKNOWN" ] && die "Couldn't determine the size of these staged files, so the size
guard can't vouch for them:$UNKNOWN
Check them by hand, or remove them from this commit."
[ -n "$BIG" ] && die "These files exceed ${MAX_FILE_KB} KB — usually a build artifact,
model, or media file that slipped past .gitignore:$BIG
Add them to .gitignore, then run this script again."
[ "$COUNT" -gt 0 ] && ok "No oversized files staged"

# ── 7. WARN: nested repos, whose contents this repo does NOT contain ────────
NESTED="$(find . -mindepth 2 -name .git -not -path './.git/*' 2>/dev/null || true)"
if [ -n "$NESTED" ]; then
  warn "Nested git repo(s) — their contents are NOT in this backup:"
  echo "$NESTED" | sed 's|/\.git$||; s|^\./|    |'
  echo "    Make each a submodule, or remove its inner .git. See reference/backup.md."
fi

# ── 8. show the human what's going ──────────────────────────────────────────
if [ "$COUNT" -gt 0 ]; then
  echo
  echo "Changes to back up:"
  git diff --cached --stat | tail -20 | sed 's/^/  /'
fi

if [ "$DRY_RUN" = 1 ]; then
  echo
  echo "DRY RUN complete — all checks passed, nothing pushed."
  git reset -q
  exit 0
fi

# Keep our own log out of the repo, or every run has a change to commit.
# Done AFTER the dry-run exit, so a dry run never edits a file.
if ! git check-ignore -q backup.log 2>/dev/null; then
  printf '\nbackup.log\n' >> "$PROJECT/.gitignore"
  git rm -q --cached backup.log 2>/dev/null
  git add -- .gitignore
fi

# ── 9. commit ───────────────────────────────────────────────────────────────
if ! git diff --cached --quiet; then
  MSG="Backup $(date '+%Y-%m-%d %H:%M') — ${COUNT} file(s) changed"
  git commit -q -m "$MSG" || die "The commit failed — see the error above.
If it mentions user.email, set it once:
    git config user.email \"you@example.com\" && git config user.name \"Your Name\""
  ok "Committed locally"
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[ "$BRANCH" = "HEAD" ] && die "You're on a detached HEAD, so there's no branch to push.
Check out a branch first:  git checkout main"

# ── 10. push ────────────────────────────────────────────────────────────────
# The token is passed to git via GIT_ASKPASS — never in the remote URL (which
# would put it in argv, visible to `ps`, and in git's error output), never in
# git config, never in the log.
TOKEN="${GIT_PUSH_TOKEN:-}"
[ -z "$TOKEN" ] && [ -n "$TOKEN_COMMAND" ] && TOKEN="$(eval "$TOKEN_COMMAND" 2>/dev/null || true)"

PUSH_ERR="$TMPDIR_RUN/push-err"
if [ -n "$TOKEN" ] && echo "$REMOTE_URL" | grep -q '^https://'; then
  ASKPASS="$TMPDIR_RUN/askpass.sh"
  { printf '#!/bin/sh\ncase "$1" in *[Uu]sername*) echo "%s";; *) cat "%s";; esac\n' \
      "x-access-token" "$TMPDIR_RUN/tok" ; } > "$ASKPASS"
  printf '%s' "$TOKEN" > "$TMPDIR_RUN/tok"
  chmod 600 "$TMPDIR_RUN/tok"; chmod 700 "$ASKPASS"
  unset TOKEN
  ok "Using the token from your credential store"
  GIT_ASKPASS="$ASKPASS" GIT_TERMINAL_PROMPT=0 \
    git push -q -u origin "$BRANCH" 2>"$PUSH_ERR" && PUSH_OK=1 || PUSH_OK=0
else
  git push -q -u origin "$BRANCH" 2>"$PUSH_ERR" && PUSH_OK=1 || PUSH_OK=0
fi

if [ "$PUSH_OK" = 1 ]; then
  ok "Pushed ($BRANCH)"
  echo "$(date '+%F %H:%M')  pushed  ${COUNT} file(s)  $(git rev-parse --short HEAD)" >> "$LOG"
  echo
  echo "Done. Your work is safe off this machine."
else
  echo "$(date '+%F %H:%M')  PUSH FAILED — commit $(git rev-parse --short HEAD) is LOCAL ONLY" >> "$LOG"
  warn "The commit is saved locally but the push failed:"
  sed -E 's#https://[^@]*@#https://***@#g' "$PUSH_ERR" | sed 's/^/    /' >&2
  echo
  if grep -q "workflow" "$PUSH_ERR" 2>/dev/null; then
    echo "Nothing is lost. GitHub refused the push because your token lacks the"
    echo "'workflow' permission (this commit changes a file under .github/workflows)."
    echo "Make a new classic token with 'repo' and 'workflow' ticked, store it again,"
    echo "then run this script again — it will retry the unpushed commit."
  else
    echo "Nothing is lost, but it is still only on this machine. The usual cause is an"
    echo "expired token. Refresh it, then run this script again — the next run will"
    echo "detect the unpushed commit and retry it."
  fi
  exit 1
fi

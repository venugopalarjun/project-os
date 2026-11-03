# Example Ledger — Decision Log

**Last updated:** 2026-03-21 (D-044 — bulk edit scoped to single-invoice assignment)

Newest first. Sequential IDs, never reused, never deleted. A reversed decision gets marked
`superseded by D-0XX` and stays.

*(Excerpt — four representative entries from a log of 44.)*

---

## D-044 · 2026-03-21 · Bulk edit assigns many transactions to one invoice, not many-to-many

**Decision:** the first version of bulk edit supports selecting N unmatched transactions and assigning them all to a single invoice, with one undo covering the whole batch. Many-to-many assignment is out of scope.

**Mechanism:** checkbox selection in the unmatched list → invoice picker → one `batch_id` written across the created matches → undo deletes by `batch_id`. No partial undo.

**Why:** four of five beta users asked for bulk correction, and when asked for examples every case was "this client paid five invoices in one transfer" or "these twelve line items all belong to invoice 402" — all many-to-one. Many-to-many is a real case but nobody has hit it, and it roughly triples the undo complexity. Deferred rather than rejected; see ROADMAP.

**Status:** `CODE WRITTEN` 2026-03-21 — needs the owner's staging run before it goes near a real ledger.

---

## D-042 · 2026-03-14 · Import runs as a queued job, not inline in the request

**Decision:** file imports are accepted, written to blob storage, and processed by a background worker. The upload endpoint returns a job ID immediately.

**Mechanism:** upload → blob store → row in `import_jobs` → worker polls every 2s → client polls a status endpoint. Three retries, then the row parks as `failed` with the parse error attached.

**Why:** three of the five beta users import spreadsheets over 40 MB, which took long enough inline to hit the platform's request timeout — and a timeout mid-parse left half a ledger written. Considered raising the timeout: it papers over the failure rather than fixing it and doesn't survive a bigger file. Considered client-side parsing: rejected because the validation rules would then live in two places (D-031).

**Status:** `SHIPPED` 2026-03-20, verified by the owner on staging with a 60 MB file.

---

## D-019 · 2026-02-02 · Deploy always precedes migration

**Decision:** the release sequence is deploy the new app, *then* run the migration. Never the reverse.

**Why:** learned the expensive way on 2026-02-01. Migrating first left the old app writing rows the new schema rejected, and the seed data corrupted silently for about forty minutes before anyone noticed. There is no clean rollback — recovery was a manual restore from the nightly backup and cost a day of beta data. The new app is always written to tolerate the old schema for one release, which makes deploy-first safe and migrate-first not.

**Status:** `LIVE` — encoded in `scripts/release.sh` and in the hard constraints list.

---

## D-007 · 2026-01-15 · Keep the current queue library

**Decision:** stay on the existing queue library rather than moving to the more popular alternative.

**Why:** the alternative's retry semantics drop a job's error context on the final failure, and a parked import needs to tell the user *why* it failed — that's the whole recovery path. The popularity gap isn't worth losing that. Re-evaluated 2026-03-05 (D-036) with the same conclusion.

**Status:** `LIVE`. Reconfirmed by D-036. *Do not re-propose without stating what has changed.*

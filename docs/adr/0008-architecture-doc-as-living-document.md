# 0008. Record the fork-and-retarget design in a living ARCHITECTURE.md

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0007
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The design knowledge behind the pack — why it forks crispy-bootstrap5 rather
than crispy-tailwind, the four Hummingbird divergences, the
emits-classes-only invariant, the golden-file testing workflow — lived only
in a git-ignored local notes file. A contributor (or a future
django-crispy-forms org review) had no way to see any of it. The Tim
Schilling session guidance calls for an architecture document contributors
can actually read.

## What did we try?

### Attempt 1 — back-fill ADRs for the original build decisions   <!-- ❌ rejected -->

Writing ADRs 000X for the Phase 0–3 fork decisions after the fact. Rejected
on principle: an ADR records a decision *as it's made*; a chain
reconstructed from memory is exactly the failure mode ADRs exist to avoid.

### Attempt 2 — living ARCHITECTURE.md   <!-- ✅ chosen -->

A current-state document (the django-stateless-mcp pattern): provenance and
the why-bootstrap5 rationale, the four divergences, template-pack mechanics,
the hard invariant, and the three-tier testing scheme with the golden-file
regeneration rule.

## What did we land on, and why?

Root `ARCHITECTURE.md`, linked from README (Development) and CONTRIBUTING.
It is explicitly **living**: shape-changing PRs update it in the same PR,
while the decision history stays frozen in `docs/adr/`. The two documents
answer different questions ("what is it now?" vs "why, and what was
rejected?") and neither substitutes for the other.

## What does this cost us?

- One more document that can drift; mitigated by the update-in-same-PR rule
  and its deliberately small scope (shape, invariants, testing — no
  API listing that duplicates the README).

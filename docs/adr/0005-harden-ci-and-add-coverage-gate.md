# 0005. Harden CI to the baseline shape and add a coverage gate

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0004
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The inherited CI (`test.yml`) was soft: unpinned floating action tags
(`checkout@v3`, `setup-python@v4`), no top-level `permissions: {}` deny, no
concurrency cancellation, credentials persisted by default, no type-check
job, no coverage, no security scanning, no advisory canaries, and no single
required check for branch protection. Dependabot's first PRs (#2, #3) were
already trying to bump the stale action tags.

## What did we try?

Direct port of the django-stateless-mcp workflow set — evaluated once
against this repo's differences (template pack, no example app, no
conformance suite) rather than trial-and-error. The MCP-specific jobs
(conformance, multi-worker fleet) have no analogue and were dropped.

## What did we land on, and why?

- **`ci.yml`** replaces `test.yml`: every action pinned to a commit SHA,
  `permissions: {}` at the top with per-job `contents: read`,
  `persist-credentials: false`, concurrency cancellation, and jobs: lint
  (ruff), type-check (mypy), test (py3.10–3.14 via `uvx --with tox-uv`,
  release factor), an **advisory** `test-crispy-main` job
  (`continue-on-error`, django-crispy-forms git main — upstream can break us
  through no fault of ours), coverage combine/report, and an
  `all-checks-pass` gate (`re-actors/alls-green`) as the one required check.
- **Coverage**: `coverage run` inside every tox env (`run.parallel`,
  `run.branch`), per-Python artifacts combined in CI, report in the step
  summary. A `paths.source` mapping folds wheel-installed
  (`*/site-packages/`) paths back to the source tree so combine works.
  Gate: `fail_under = 97` — measured 99% and set two points under, per the
  measure-first rule rather than an aspirational number.
- **`codeql.yml`** (python, `security-extended`, weekly + per-PR) and
  **`zizmor.yml`** (workflow-security lint, path-filtered). Both ported
  verbatim; zizmor verified locally against the new workflow set before
  commit (no findings).
- **`django-main.yml`**: weekly advisory run (Mondays 06:00 UTC) of the
  `djangomain` tox factor added in ADR-0004's PR, py3.12–3.14 — the
  early-warning canary for the next Django.
- Dependabot PRs #2/#3 (action tag bumps) are superseded by the SHA pins and
  closed; Dependabot maintains the pinned SHAs from here.

## What does this cost us?

- SHA pins make action updates Dependabot's job; a broken action can't be
  hot-fixed by a floating tag.
- The coverage gate can fail a PR that only removes covered test code;
  adjust the floor deliberately (with an ADR) rather than reflexively.
- The advisory jobs are noise when upstream breaks — deliberately non-blocking.

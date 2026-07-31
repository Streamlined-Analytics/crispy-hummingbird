# 0001. Adopt the django-stateless-mcp engineering baseline (phase 2: metadata & supply-chain quick wins)

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** none — first ADR for engineering-baseline (and the first ADR in this repository)
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

crispy-hummingbird was forked from crispy-bootstrap5 and published to PyPI
(0.1.0, 2026-07-14) with the upstream project's minimal scaffolding: two soft
CI workflows, three pre-commit hooks, no Dependabot, no coverage, no community
files, and no decision records. Our other published package,
[django-stateless-mcp](https://github.com/Streamlined-Analytics/django-stateless-mcp),
went through a mentoring-informed hardening pass (the well-maintained test,
Django Commons best practices) and now defines the engineering bar for our
open-source work.

A full audit of this repo against that bar (2026-07-31) found the gaps above
plus several latent metadata defects: `requires-python = ">=3.9"` and
`django>=4.2` floors that contradict the classifiers and the tested matrix
(py3.10–3.14 × Django 5.2/6.0; Django 4.2 reached EOL in April 2026), project
URLs pointing at the pre-transfer `BenA-SA` owner, no maintainer entry, no
`Development Status` classifier, a stale "unreleased"/"not yet published"
CHANGELOG and README, a committed scratch file (`test.html`), and a lint
typo — `isort --check --dif` — that silently weakened the isort check.

The same day the repo was transferred to the Streamlined-Analytics org so PRs
get Seer review (the org installation covers all repositories).

## What did we try?

### Attempt 1 — one-shot adoption of the full baseline   <!-- ❌ rejected up front -->

Port everything from django-stateless-mcp in a single PR: hardened workflows,
CodeQL, zizmor, coverage, community files, plus a ruff and uv migration.
Rejected: it bundles mechanical fixes with two genuine open decisions —
swapping black/isort/flake8 for ruff, and setuptools/pip for uv — that trade
against staying close to upstream crispy-bootstrap5 (which matters if the
pack is later pitched to the django-crispy-forms org). It would also be
unreviewable as one diff.

### Attempt 2 — phased adoption, decisions deferred   <!-- ✅ chosen -->

Work the audit's ordered plan: this PR takes only the zero-decision quick
wins; CI hardening, coverage, and community files follow as their own PRs
with their own ADRs; the ruff/uv questions stay open until explicitly
decided.

## What did we land on, and why?

Phased adoption, starting with this PR:

- **Declared floors now match the tested matrix**: `requires-python = ">=3.10"`,
  `django>=5.2`. The old floors advertised support (py3.9, Django 4.2) that no
  CI job has ever exercised; an untested claim is worse than a narrower one,
  and 4.2 is EOL. Acceptable at 0.x with one known consumer (safersphere, on
  Django 5.2).
- **`Development Status :: 4 - Beta`** — the pack is a near-verbatim fork of a
  mature upstream, has 120 passing tests, and is in production use; Beta is
  honest without overclaiming Production/Stable this early.
- **Maintainer added alongside the upstream author** — David Smith stays as
  author (attribution), Ben Atkinson listed as maintainer.
- **Dependabot with a 7-day cooldown** on `github-actions` and `pip` — the
  org's standard supply-chain quarantine, mirroring django-stateless-mcp's
  config verbatim.
- **Housekeeping**: project URLs moved to `Streamlined-Analytics`, the
  `isort --dif` typo fixed, `test.html` removed, CHANGELOG dated for the
  0.1.0 release, README refreshed (badges, published install instructions,
  supported-versions and development sections).

## What does this cost us?

- The floor raise means a hypothetical Django 4.2/py3.9 user of 0.1.0 cannot
  upgrade to the next release — accepted knowingly; nothing tested ever
  supported them.
- Metadata now diverges slightly from upstream crispy-bootstrap5, a small
  extra burden when rebasing against the `upstream` remote.
- The remaining audit phases (hardened SHA-pinned workflows, CodeQL, zizmor,
  `all-checks-pass` gate, weekly Django-main run, `django61` factor,
  coverage, community files) are follow-up PRs, each carrying its own ADR.
  The ruff-vs-upstream-lint and uv-vs-setuptools decisions remain open.

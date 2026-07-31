# 0003. Adopt uv with a one-week exclude-newer supply-chain quarantine

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0001
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The project managed dependencies with bare pip + dependency-groups: no
lockfile, no freshness guard on resolution, and slower CI installs. The
Dependabot 7-day cooldown added in ADR-0001 quarantines *update PRs*, but
nothing stopped a fresh local or CI resolve from picking up a
minutes-old (potentially compromised) release. House rule: uv projects carry
`exclude-newer = "1 week"` so the resolver itself refuses anything younger
than the quarantine window.

## What did we try?

### Attempt 1 — stay on pip/setuptools   <!-- ❌ rejected -->

Zero churn and upstream parity, but leaves the supply-chain window open and
the environment unreproducible (no lock). Rejected — the Dependabot cooldown
alone guards only one of the two resolution paths.

### Attempt 2 — full stateless-mcp shape including hatchling   <!-- ❌ rejected -->

Also switching the build backend to hatchling was considered for symmetry.
Rejected: the setuptools backend + `MANIFEST.in` + dynamic
`__version__` packaging already works (42 templates verified in the wheel)
and is upstream's shape; the backend is orthogonal to what uv solves.

### Attempt 3 — uv as resolver/installer only   <!-- ✅ chosen -->

`[tool.uv]` with `exclude-newer = "1 week"`, `required-version = ">=0.9.17"`
(first version parsing relative durations), `default-groups = ["dev"]`, and a
committed `uv.lock`. Build backend, MANIFEST.in, and dynamic version stay
setuptools.

## What did we land on, and why?

Attempt 3. The dev loop becomes `uv sync` / `uv run pytest` /
`uvx --with tox-uv tox`; the resolver quarantine now matches the Dependabot
cooldown so both freshness paths agree. One knock-on fix: `uv run pytest`
does not put the repo root on `sys.path` the way `python -m pytest` did, so
pytest config gained `pythonpath = ["."]`, `django_find_project = false`, and
`testpaths = ["tests"]`.

## What does this cost us?

- `uv.lock` (~sizeable generated file) now lives in the repo and churns with
  Dependabot updates.
- Contributors need uv (>= 0.9.17); plain pip still works for consumers —
  only the dev workflow changed.
- A genuinely urgent dependency fix inside the 1-week window needs a
  per-package `exclude-newer-package` exemption (see django-stateless-mcp's
  ADR-0005 for the pattern), tracked with a removal date.

# 0002. Migrate the lint stack from black/isort/flake8 to ruff

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0001
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The fork inherited upstream crispy-bootstrap5's lint stack: black + isort +
flake8, three tools with three configs and floating pre-commit tag revs. Our
engineering baseline (django-stateless-mcp, ADR-0001 here) standardises on
ruff: one tool covering formatting (ruff-format is black-compatible), import
sorting (`I`), and linting (`E`/`F`/`W`/`B`/`UP`), configured in pyproject and
fast enough for pre-commit.ci. ADR-0001 deferred this because it trades
against upstream parity.

## What did we try?

### Attempt 1 — keep black/isort/flake8   <!-- ❌ rejected -->

Upstream-parity argument: byte-identical tooling keeps rebases against the
`upstream` remote clean and a future django-crispy-forms org pitch
frictionless. Rejected because the divergence is config-only and trivially
revertible, while the maintenance cost (three tools, three version streams,
no single-config source of truth) is paid continuously.

### Attempt 2 — ruff, keeping the existing style   <!-- ✅ chosen -->

Ruff at **line-length 88** (the existing black setting — NOT stateless-mcp's
120), rule set `B,E,F,I,UP,W`. The one-time reformat touched only a handful
of files; 13 `UP031` percent-format modernisations in tests were applied via
ruff's own fixes.

## What did we land on, and why?

Ruff via pre-commit (`ruff-check --fix` + `ruff-format`, SHA-frozen revs) and
tox (`[testenv:lint]`). black/isort/flake8 removed from dependency groups and
config. Two deliberate scopes:

- `lint.per-file-ignores."tests/*" = ["B017"]` — blind
  `pytest.raises(Exception)` is an upstream test idiom; narrowing the
  exceptions is upstream's call, not ours.
- The whitespace hooks (`trailing-whitespace`, `end-of-file-fixer`) **exclude
  `crispy_hummingbird/templates/` and `tests/results/`**. Found the hard way:
  the first `--all-files` run stripped trailing whitespace inside templates,
  which changed rendered output and broke a whitespace-sensitive assertion
  (`test_tab_helper_reuse`). Template whitespace is rendered output, and the
  golden fixtures mirror it — neither is "trailing whitespace" to clean.

## What does this cost us?

- Tooling now diverges from upstream crispy-bootstrap5 — a small extra diff
  surface when rebasing, and something to flag (or revert) in any org pitch.
- The tests' percent-format modernisation is churn against upstream test
  files; accepted as mechanical and ruff-enforced from now on.

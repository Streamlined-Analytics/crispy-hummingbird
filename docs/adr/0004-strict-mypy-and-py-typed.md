# 0004. Strict mypy with django-stubs, and ship py.typed

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0001
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The package had no type checking (upstream crispy-bootstrap5 has none). Our
baseline treats published types as a consumer-checkable contract: mypy
`strict` + django-stubs, with `py.typed` in the wheel. The Python surface
here is tiny (two modules, three layout-object classes), so the cost is low.

## What did we try?

### Attempt 1 — strict everywhere, tests included   <!-- ❌ failed in practice -->

`strict = true` over `crispy_hummingbird/` + `tests/` produced **320 errors,
all in tests** — strict enables `check_untyped_defs`, and the upstream test
suite assigns `form.helper` dynamically everywhere. Annotating hundreds of
upstream-derived call sites would fight the fork base for zero safety gain.

### Attempt 2 — strict package, relaxed tests   <!-- ✅ chosen -->

Per-module overrides: `tests.*` gets `allow_untyped_defs`,
`check_untyped_defs = false`, `disallow_any_generics = false`;
`crispy_forms.*` gets `ignore_missing_imports` (it ships no `py.typed`, so
its classes resolve to `Any`); `crispy_hummingbird.*` gets
`disallow_subclassing_any = false` (our layout objects subclass those
`Any`-typed classes).

## What did we land on, and why?

Attempt 2, wired three ways: a `type-check` step in `just qa`, a local
pre-commit hook (`uv run mypy`, skipped on pre-commit.ci which lacks the
project env), and — in the next CI rewrite — a dedicated job. `py.typed`
ships via MANIFEST.in + setuptools `include_package_data`; the `Typing ::
Typed` classifier is set.

The pass immediately paid for itself: mypy flagged that the tests imported
`formset_factory` from `django.forms.models`, where it does not live — it
works at runtime only via Django's internal re-imports. Fixed to the
canonical `django.forms.formsets` import.

## What does this cost us?

- The package's public annotations are now API: tightening or loosening them
  is a consumer-visible change.
- The `crispy_forms` `Any` boundary means mypy cannot check our calls *into*
  crispy-forms — the strictness covers our layer only. If upstream ever ships
  `py.typed`, drop the overrides and re-run.
- Test files remain essentially unchecked by design; new *package* code never
  gets that exemption.

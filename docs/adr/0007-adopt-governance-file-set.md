# 0007. Adopt the governance file set, including AI-provenance disclosure

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0006
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The repo had no contributor-facing governance: no CONTRIBUTING, code of
conduct, security policy, or issue/PR templates. For a published package
inviting external issues and PRs (and scoring against the well-maintained
test), these are table stakes; django-stateless-mcp already carries the
house set.

## What did we try?

Direct port from django-stateless-mcp with content adapted, not invented.
Two adaptations worth recording:

- The bug template asks for the **four-version tuple** (crispy-hummingbird,
  django-crispy-forms, Django, Python) and the form/layout definition — a
  template pack's bugs are almost always "this layout renders wrong markup
  under version X".
- CONTRIBUTING documents the two repo-specific traps: golden-file fixtures
  as the test currency for template changes, and the rule that template
  whitespace is rendered output (do not "clean" it — ADR-0002's exclusion).

## What did we land on, and why?

CONTRIBUTING.md, CODE_OF_CONDUCT.md (Contributor Covenant, same contact),
SECURITY.md (private vulnerability reporting + the hardening inventory from
ADR-0005/0006), issue templates (bug/feature/config), and the PR template.

The one real decision: the PR template keeps the **AI Provenance** section —
contributors disclose tool, model, and prompt/thread for AI-authored PRs.
Mirrors stateless-mcp and the "docs shouldn't read as entirely AI-generated"
session guidance: disclosure makes review calibration possible.

## What does this cost us?

- Governance text is now a maintenance surface (contact details, workflow
  names referenced in SECURITY.md must track reality).
- The AI-provenance ask adds friction for drive-by contributors; accepted as
  proportionate.

# Architecture

How crispy-hummingbird works, why it's shaped this way, and the invariants a
change must preserve. This is a **living document** — a PR that changes the
shape described here updates it in the same PR. (The *decisions* behind the
shape are frozen in `docs/adr/`.)

## What this package is

A [django-crispy-forms](https://django-crispy-forms.readthedocs.io/) template
pack for [Hummingbird UI](https://hbui.dev) — the Tailwind CSS v4 component
system. A template pack is almost entirely **templates**: the Python surface
is one module of layout objects (`crispy_hummingbird/hummingbird.py`) and a
version string. Everything interesting happens in
`crispy_hummingbird/templates/hummingbird/`.

## Provenance: a fork of crispy-bootstrap5, on purpose

The pack is forked from
[crispy-bootstrap5](https://github.com/django-crispy-forms/crispy-bootstrap5)
(MIT, attribution retained in README and LICENSE; the fork base is kept as
the `upstream` git remote for rebasing).

**Why bootstrap5 and not crispy-tailwind:** Hummingbird deliberately reuses
Bootstrap 5's *form class names* (`form-control`, `form-select`,
`form-label`, `form-check`, `is-invalid`, `invalid-feedback`,
`input-group`, `form-range`, `.row`, `btn`, …), so bootstrap5's
static-class templates are a near-exact match — roughly 80% of its output
works verbatim. `crispy-tailwind` instead injects bespoke utility classes
through a `{% tailwind_field %}` tag, which is the wrong model for a
Bootstrap-class-compatible system.

This provenance is load-bearing: **stay close to upstream**. The smaller our
diff against crispy-bootstrap5, the cheaper it is to pull upstream fixes and
the easier the pack is to review.

## The four divergences (the entire Hummingbird delta)

Everything the pack changes relative to crispy-bootstrap5, verified against
Hummingbird's own compiled CSS (`@hummingbirdui/hummingbird` →
`src/components/*.css`, `src/layout/grid.css`):

1. **Field wrapper: `form-field`, not `mb-3`.** Every labeled field wraps in
   `<div class="form-field">`. Mechanical rename across the pack's templates.
2. **Checkbox/radio inputs wrap in `<label class="form-check-input-wrapper">`.**
   Hummingbird's checkbox markup nests the input in a wrapper label that
   Bootstrap doesn't have. The only genuinely structural change; lives in
   `field.html` (single-checkbox path), `layout/radio_checkbox_select.html`,
   and `layout/inline_field.html`.
3. **Column default: `col`, not `col-md`.** Hummingbird's Bootstrap-compat
   grid is non-responsive (`col`, `col-1..12` — no `col-md-*`), so
   `layout/column.html` falls back to `col`. Consumers wanting responsive
   layouts use Tailwind grid utilities directly.
4. **Switch: ARIA `role="switch"`** in `layout/switch.html` (plus the
   `form-field` wrapper swap).

Anything else that differs from upstream is a bug in principle — compare
before "fixing" rendered output.

## Template-pack mechanics

- **Self-contained pack** (crispy-forms ≥ 1.5 rule): every template the pack
  needs lives under `templates/hummingbird/`; no cross-pack references.
- **`field.html` resolves at the pack root**, not under `layout/`.
- Consumers register with `INSTALLED_APPS += ["crispy_hummingbird"]`,
  `CRISPY_ALLOWED_TEMPLATE_PACKS = "hummingbird"`,
  `CRISPY_TEMPLATE_PACK = "hummingbird"`; `FormHelper.template_pack`
  overrides per-form, so the pack coexists with bootstrap5/others.
- **Layout objects** (`hummingbird.py`): `FloatingField`, `Switch`,
  `HBAccordion` (with `BS5Accordion` kept as a migration alias). They only
  point at pack templates; behavior stays upstream's.

## The one hard invariant

**The pack emits class names; it never ships styling.** Hummingbird's CSS
(the consumer's `@import "@hummingbirdui/hummingbird"`) owns all appearance.
No inline styles, no bundled CSS, no `<style>` blocks.

A softer but real invariant: **template whitespace is rendered output.**
Tests assert against rendered markup (sometimes whitespace-sensitively), and
fixtures mirror it byte-for-byte — so formatting tools must not touch
`crispy_hummingbird/templates/` or `tests/results/` (the pre-commit
whitespace hooks exclude both; see ADR-0002).

## Testing: three assertion tiers

Rendering is compared with Django's own `django.test.html.parse_html`
(no DB — forms render to strings; settings in `tests/test_settings.py`):

1. **Substring** — `cls in html` for a single class or attribute.
2. **Count** — `html.count("form-field") == N` for wrapper/structure counts.
3. **Golden files** — `parse_form(form) == parse_expected("x.html")` against
   the fixtures in `tests/results/` (the main currency for template changes).

**Regenerating golden files** after an intentional template change: render
the sample form, eyeball the diff to confirm *only* the intended divergence
changed, and overwrite the fixture. Never regenerate blind — the eyeball is
the review.

The tox matrix runs Python 3.10–3.14 × released Django lines (+ a Django 6.1
pre-release factor) × django-crispy-forms release/git-main, with
deprecation and resource warnings as errors. `tests/` files are
upstream-derived: they're exempt from strict typing (ADR-0004) and keep
upstream idioms.

## Engineering baseline

Tooling (uv, ruff, strict mypy + `py.typed`, SHA-pinned hardened CI,
coverage gate, provenance-attested publishing) mirrors
[django-stateless-mcp](https://github.com/Streamlined-Analytics/django-stateless-mcp);
the decision trail is `docs/adr/0001`–`0007`.

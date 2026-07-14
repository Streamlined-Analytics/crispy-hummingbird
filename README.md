# crispy-hummingbird

A [django-crispy-forms](https://github.com/django-crispy-forms/django-crispy-forms) template pack
for [**Hummingbird UI**](https://hbui.dev) — the Tailwind CSS v4 component system (used by the
Falcon-Tailwind theme).

> **Status: work in progress (v0.1.0).** Core form rendering works; full layout-object coverage,
> regenerated test fixtures, and docs are in progress.

## Why

Hummingbird reuses Bootstrap 5's form class names (`form-control`, `form-select`, `form-label`,
`form-check`, `is-invalid`, `input-group`, …), so this pack is a small, faithful adaptation of
[`crispy-bootstrap5`](https://github.com/django-crispy-forms/crispy-bootstrap5) — it emits the class
names Hummingbird styles, with a handful of Hummingbird-specific divergences (field wrapper
`form-field`, a `form-check-input-wrapper` around checkbox/radio inputs, and Hummingbird's
non-responsive `col` grid).

## Installation

```bash
pip install crispy-hummingbird   # not yet published — install from source for now
```

Add to your Django settings:

```python
INSTALLED_APPS = [
    # ...
    "crispy_forms",
    "crispy_hummingbird",
]

CRISPY_ALLOWED_TEMPLATE_PACKS = "hummingbird"
CRISPY_TEMPLATE_PACK = "hummingbird"
```

You also need Hummingbird's CSS in your build (e.g. `@import "@hummingbirdui/hummingbird";` in your
Tailwind entry). This pack only emits class names; Hummingbird provides the styling.

## Usage

Use django-crispy-forms exactly as normal — `{% crispy %}`, the `|crispy` filter, `FormHelper`, and
`Layout` objects all work. To opt a single form into Hummingbird while another pack is the project
default:

```python
helper = FormHelper()
helper.template_pack = "hummingbird"
```

## Credits

Forked from [`crispy-bootstrap5`](https://github.com/django-crispy-forms/crispy-bootstrap5) by
David Smith and the django-crispy-forms team (MIT). See `LICENSE`.

## License

MIT.

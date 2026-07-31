# crispy-hummingbird

[![PyPI version](https://img.shields.io/pypi/v/crispy-hummingbird.svg)](https://pypi.org/project/crispy-hummingbird/)
[![Tests](https://github.com/Streamlined-Analytics/crispy-hummingbird/actions/workflows/test.yml/badge.svg)](https://github.com/Streamlined-Analytics/crispy-hummingbird/actions/workflows/test.yml)

A [django-crispy-forms](https://github.com/django-crispy-forms/django-crispy-forms) template pack
for [**Hummingbird UI**](https://hbui.dev) — the Tailwind CSS v4 component system (used by the
Falcon-Tailwind theme).

* [GitHub](https://github.com/Streamlined-Analytics/crispy-hummingbird) | [PyPI](https://pypi.org/project/crispy-hummingbird/)
* MIT License

## Why

Hummingbird reuses Bootstrap 5's form class names (`form-control`, `form-select`, `form-label`,
`form-check`, `is-invalid`, `input-group`, …), so this pack is a small, faithful adaptation of
[`crispy-bootstrap5`](https://github.com/django-crispy-forms/crispy-bootstrap5) — it emits the class
names Hummingbird styles, with a handful of Hummingbird-specific divergences (field wrapper
`form-field`, a `form-check-input-wrapper` around checkbox/radio inputs, and Hummingbird's
non-responsive `col` grid).

## Installation

```bash
pip install crispy-hummingbird
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

## Supported versions

* Python 3.10–3.14
* Django 5.2 LTS and 6.0
* django-crispy-forms >= 2.3

Each combination is exercised in CI, along with an advisory run against
django-crispy-forms git main.

## Development

```bash
git clone git@github.com:Streamlined-Analytics/crispy-hummingbird.git
cd crispy-hummingbird
uv sync

uv run pytest                        # quick run
uvx --with tox-uv tox run -f py313   # one Python across the Django matrix
just qa                              # format, lint, type check, test
```

## Credits

Forked from [`crispy-bootstrap5`](https://github.com/django-crispy-forms/crispy-bootstrap5) by
David Smith and the django-crispy-forms team (MIT). See `LICENSE`.

## License

MIT.

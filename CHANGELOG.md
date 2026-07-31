# CHANGELOG FOR CRISPY-HUMMINGBIRD

## Unreleased
* Repository moved to the [Streamlined-Analytics](https://github.com/Streamlined-Analytics) organization; project URLs updated.
* Declared floors now match the tested matrix: Python >= 3.10, Django >= 5.2 (Django 4.2 and
  Python 3.9 were never in the test matrix and 4.2 reached end of life in April 2026).
* Packaging metadata: added maintainer and `Development Status :: 4 - Beta` classifier.

## 0.1.0 (2026-07-14)
* Initial release. Forked from `crispy-bootstrap5` and retargeted to Hummingbird UI:
  * Renamed package `crispy_hummingbird`, template pack `hummingbird`.
  * Field wrapper uses Hummingbird's `form-field` (instead of Bootstrap's `mb-3`).
  * Checkbox/radio inputs wrapped in `<label class="form-check-input-wrapper">` per Hummingbird.
  * `Column` renders Hummingbird's non-responsive `col` (Hummingbird has no `col-md-*`).
  * `Switch` renders `role="switch"` (ARIA-correct) rather than `role="checkbox"`.
  * Accordion layout object renamed `BS5Accordion` → `HBAccordion`; `BS5Accordion` kept as an alias
    for anyone migrating from `crispy-bootstrap5`.
* Bootstrap-5-compatible form classes (`form-control`, `form-select`, `is-invalid`,
  `invalid-feedback`, `input-group`, `form-text`, `.row`, `btn`) pass through unchanged.

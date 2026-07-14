# CHANGELOG FOR CRISPY-HUMMINGBIRD

## 0.1.0 (unreleased)
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

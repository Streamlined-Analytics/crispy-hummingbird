# Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

You can contribute in many ways:

## Types of Contributions

### Report Bugs

Report bugs at https://github.com/Streamlined-Analytics/crispy-hummingbird/issues.

If you are reporting a bug, please include:

- The crispy-hummingbird, django-crispy-forms, Django, and Python versions you're using.
- The form/layout definition that renders incorrectly, and the markup you expected.
- Any details about your setup that might be helpful in troubleshooting.

### Fix Bugs

Look through the GitHub issues for bugs. Anything tagged with "bug" and "help wanted" is open to whoever wants to implement it.

### Implement Features

Look through the GitHub issues for features. Anything tagged with "enhancement" and "help wanted" is open to whoever wants to implement it. Hummingbird features the pack doesn't cover yet (filled `-fill` variants, floating labels) are good candidates.

### Write Documentation

crispy-hummingbird could always use more documentation, whether in the README, in docstrings, or in blog posts and articles.

### Submit Feedback

The best way to send feedback is to file an issue at https://github.com/Streamlined-Analytics/crispy-hummingbird/issues.

If you are proposing a feature:

- Explain in detail how it would work.
- Keep the scope as narrow as possible, to make it easier to implement.
- Remember that this is a volunteer-driven project, and that contributions are welcome :)

## Get Started!

Ready to contribute? Start with [ARCHITECTURE.md](ARCHITECTURE.md) — the map of how
the pack works, its fork provenance, and the invariants every change must preserve.
Then here's how to set up crispy-hummingbird for local development.

1. Fork the crispy-hummingbird repo on GitHub.
2. Clone your fork locally:

   ```sh
   git clone git@github.com:your_name_here/crispy-hummingbird.git
   ```

3. Install your local copy with [uv](https://docs.astral.sh/uv/):

   ```sh
   cd crispy-hummingbird/
   uv sync
   ```

4. Create a branch for local development:

   ```sh
   git checkout -b name-of-your-bugfix-or-feature
   ```

   Now you can make your changes locally.

5. When you're done making changes, check that your changes pass linting, type checking, and the tests:

   ```sh
   just qa
   ```

   Or run the tests alone:

   ```sh
   uv run pytest
   ```

   The full supported matrix (Python × Django × django-crispy-forms) runs with:

   ```sh
   uvx --with tox-uv tox run
   ```

6. Commit your changes and push your branch to GitHub:

   ```sh
   git add .
   git commit -m "Your detailed description of your changes."
   git push origin name-of-your-bugfix-or-feature
   ```

7. Submit a pull request through the GitHub website.

## Pull Request Guidelines

Before you submit a pull request, check that it meets these guidelines:

1. The pull request should include tests. Template changes usually need a golden-file
   fixture in `tests/results/` — compare with `parse_form(form) == parse_expected(...)`.
2. If the pull request adds functionality, update the README.
3. The pull request should work for Python 3.10–3.14 and every supported Django.
   CI runs the full matrix on every pull request; the `All checks pass` gate must be green.

## A note on templates

The pack's templates are forked from
[crispy-bootstrap5](https://github.com/django-crispy-forms/crispy-bootstrap5) and stay
deliberately close to upstream — only Hummingbird-specific divergences are ours.
Whitespace inside `crispy_hummingbird/templates/` is rendered output; don't "clean" it
(the pre-commit whitespace hooks exclude it for this reason).

## Releasing a New Version

1. Bump `__version__` in `crispy_hummingbird/__init__.py` and update `CHANGELOG.md`.
2. Commit, PR, merge on green.
3. Create a GitHub Release with a `v<version>` tag. The tag triggers the publish
   workflow (build → provenance attestation → PyPI trusted publishing) behind the
   gated `pypi` environment.

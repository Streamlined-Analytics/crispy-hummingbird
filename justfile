# Justfile for crispy-hummingbird

# Show available commands
list:
    @just --list

alias b := build
alias c := clean
alias t := test

# Run all the formatting, linting, type-checking, and testing commands
qa:
    uv run ruff format .
    uv run ruff check . --fix
    uv run mypy crispy_hummingbird/ tests/
    uv run pytest

# Run the tests, with arguments passed through
test *ARGS:
    uv run pytest {{ARGS}}

# Run the full supported matrix (Python x Django x crispy-forms)
testall:
    uvx --with tox-uv tox run

# Run all pre-commit hooks against the whole tree
lint:
    uv run pre-commit run --all-files

# Build the project, useful for checking that packaging is correct
build:
    rm -rf build
    rm -rf dist
    uv build

# Remove build, test, and cache artifacts
clean:
    rm -fr build/ dist/ .tox/ .pytest_cache/ .mypy_cache/ .ruff_cache/
    find . -name '*.egg-info' -exec rm -fr {} +
    find . -name '__pycache__' -exec rm -fr {} +

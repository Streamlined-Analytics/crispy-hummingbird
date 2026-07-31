# 0006. Publish on v* tags with build/publish split and provenance attestation

- **Status:** Accepted
- **Date:** 2026-07-31
- **Deciders:** Ben Atkinson
- **Feature / area:** engineering-baseline
- **Builds on:** ADR-0005
- **Supersedes / Superseded by:** none

## What problem were we trying to solve?

The inherited `publish.yml` triggered on `release: created`, re-ran the whole
5-Python test matrix inside the publish workflow, built and published in one
job with unpinned actions, and produced no provenance. Meanwhile the repo's
`pypi` environment (hardened 2026-07-31 after the org transfer) restricts
deployments to `v*` **tags** — a restriction the release-event trigger only
satisfied incidentally.

## What did we try?

Direct port of the django-stateless-mcp publish shape; the only judgement
call was the trigger. Keeping `release: created` was considered and rejected:
the tag-push trigger fires for exactly the refs the environment protection
names (`v*`), still works with the create-a-GitHub-Release flow (creating a
release pushes its tag), and additionally covers a manually pushed tag.

## What did we land on, and why?

`push: tags: v*` trigger; `permissions: {}`; a `build` job (uv build with
the setup-uv **cache disabled** — release artifacts must not be assembled
from a poisonable cache; `contents: read` only) uploading `dist/`; a
`publish` job gated by the `pypi` environment (required reviewer + `v*` tag
restriction) with `id-token: write` + `attestations: write`, running
`actions/attest-build-provenance` over the artifacts and then
`pypa/gh-action-pypi-publish` via trusted publishing. All actions SHA-pinned.

The duplicated test matrix is gone: `main` is always green behind the
`all-checks-pass` gate (ADR-0005), and a release is cut from `main` — the
publish workflow's job is packaging integrity, not re-testing.

## What does this cost us?

- Releasing from an unmerged branch tag would skip tests entirely — don't;
  the environment's required reviewer is the human backstop.
- The build/publish split means ~one extra minute of workflow time per
  release, bought back in artifact provenance and least-privilege jobs.
- First release after this change should be watched end-to-end (new trigger
  path + repointed trusted publisher in the same release).

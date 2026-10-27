# SDLC for WordPress projects

One process for every project, whether it is a plugin, a theme or a full site.

## Phases

| Phase | What happens | Artifacts | Automated by |
| --- | --- | --- | --- |
| Plan | Idea becomes an issue with acceptance criteria and a plan | Issue (templates), plan | `.github/ISSUE_TEMPLATE`, `/plan` |
| Design | Non-trivial choices are written down | `docs/ARCHITECTURE.md`, ADR in `docs/DECISIONS.md` | `/plan` drafts the ADR |
| Build | Small branches, Conventional Commits, local env | Branch, commits | `.wp-env.json`, `lefthook.yml`, `phpcs.xml` |
| Test | Static analysis, unit/integration, e2e | Green CI | `ci.yml`, `phpunit.xml.dist`, Playwright |
| Review | Human review plus agent review | PR | PR template, `/review`, agents |
| Release | SemVer tag builds a zip and a GitHub release | Tag, release notes, zip | `/release`, `release.yml` |
| Deploy | `main` is synced to the server over SSH | Backup, deploy log | `deploy.yml` |
| Operate | Monitor, respond, learn | Runbook, post-incident notes | `docs/RUNBOOK.md` |

## Branching

- Trunk-based. `main` is always deployable and protected (PR required, CI required).
- Short-lived branches: `feat/short-name`, `fix/short-name`, `chore/short-name`. Squash merge.
- Hotfix: branch from `main`, PR with the same checks, tag a patch release.

## Commits and versions

- Conventional Commits: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`. Add `!` or a `BREAKING CHANGE:` footer for breaking changes.
- SemVer: breaking -> major, `feat` -> minor, `fix` -> patch. Tags are `vX.Y.Z`.

## Environments

1. Local: `npm run env:start` (wp-env, http://localhost:8888).
2. Staging (optional): same deploy workflow with a second environment and its own secrets.
3. Production: `deploy.yml` on push to `main`, with a server-side backup before each sync.

## Definition of ready

- The problem and acceptance criteria are written down.
- Dependencies and risks (data, security, SEO, performance) are known.
- Small enough to ship in a few days or split.

## Definition of done

- `composer check` and all tests pass in CI.
- New behavior has tests, or the PR explains why not.
- Input sanitized, output escaped, nonce and capability checks in place where relevant.
- Docs updated; ADR added for architectural decisions.
- Reviewed and merged to `main`; deploy completed and verified on the live site.

## Branch protection (set once per repo)

Settings -> Branches -> rule for `main`: require a pull request, require the `lint`, `phpunit` and `e2e` checks, block force pushes. Deploy runs from `main`, so this is what keeps broken code from reaching production.

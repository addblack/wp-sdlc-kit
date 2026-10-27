# WP SDLC Kit

A drop-in software development lifecycle for any WordPress project: quality gates, CI/CD, release flow, docs and Claude Code agents, in one repository.

## What you get

| Area | Files |
| --- | --- |
| Coding standards | `phpcs.xml` (WPCS + PHPCompatibilityWP), `.editorconfig` |
| Static analysis | `phpstan.neon` (with WordPress stubs) |
| Tests | `phpunit.xml.dist` + `tests/php` (wp-env), `playwright.config.ts` + `tests/e2e` |
| Local environment | `.wp-env.json` |
| Git hooks | `lefthook.yml` (PHP lint, PHPCS, Conventional Commits) |
| CI | `.github/workflows/ci.yml` (lint on PHP 8.1 and 8.3, PHPUnit, Playwright, official Plugin Check) |
| Release | `.github/workflows/release.yml` (tag `vX.Y.Z` -> zip + GitHub release) |
| Deploy | `.github/workflows/deploy.yml` (rsync over SSH, backup, dry run) |
| Collaboration | issue templates, PR template, Dependabot |
| Docs | `docs/SDLC.md`, `ARCHITECTURE.md`, `DECISIONS.md`, `RUNBOOK.md` |
| Claude Code | `CLAUDE.md`, agents (code, security, a11y/SEO), commands (`/plan`, `/review`, `/release`), skills (plugin scaffold, safe migrations) |

The process itself is described in [docs/SDLC.md](docs/SDLC.md).

## Use it

New project: click "Use this template" on GitHub (enable it in the repo settings), then follow the next steps below.

Existing project:

```bash
git clone <this repo> wp-sdlc-kit
wp-sdlc-kit/bin/install.sh /path/to/your/project
```

Existing files are skipped, not overwritten. Use `--force` to update the kit files, `--no-claude` to skip the Claude Code files, `--no-deploy` to skip the deploy workflow.

## After installing

1. Edit `phpcs.xml` (text domain, global prefix, PHP and WP versions) and fill in the TODO lines in `CLAUDE.md`.
2. `composer install && npm install` (this also installs the git hooks).
3. `composer check` and fix what it finds. For legacy code, start with `composer lint:fix` and, if the noise is too high, baseline PHPStan and raise the level gradually.
4. `npm run env:start` for a local site on http://localhost:8888.
5. Protect `main` on GitHub: require PR and the CI checks.

## Project layouts

- Single plugin repo (default): repo root is the plugin. `.wp-env.json` mounts it as a plugin.
- Single theme repo: in `.wp-env.json` move `"."` from `plugins` to `themes`, and change `tests/bootstrap.php` to `switch_theme()`.
- Full site or `wp-content` repo: point PHPCS and PHPStan at your own code (`<file>` in `phpcs.xml`, `paths` in `phpstan.neon`) and use `DEPLOY_DIRS` (for example `themes/my-theme plugins/my-plugin`) so only your code is synced.

## Deploy setup

Set repository secrets `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH` (and `SSH_PORT`). Optional variables: `DEPLOY_DIRS`, `POST_DEPLOY_CMD` (for example `wp cache flush`). Run the workflow manually with `dry_run` enabled, read the change list, then deploy for real. Details and rollback steps are in [docs/RUNBOOK.md](docs/RUNBOOK.md).

Anything that exists only on the server (uploads, caches, custom config) must be in `.distignore`, because deploy uses `rsync --delete`.

## Claude Code

Open the project in Claude Code and the agents, commands and skills in `.claude/` are available. A typical loop: `/plan <task>`, implement in small steps, `/review`, open a PR, `/release minor` when ready.

## Updating the kit

Improve the kit in this repository, then run `bin/install.sh /path/to/project --force` in each project and review the diff with git.

## Coding standard: WPCS, not PSR-12

The kit uses WordPress Coding Standards (tabs, Yoda conditions, snake_case functions), which is what WordPress.org and most WP teams expect. PSR-12 contradicts it (spaces, camelCase), so do not enable both on the same code. PSR-4 autoloading and namespaces are fine with WPCS. If a project is not WordPress-facing (for example a Laravel package), use the `PSR12` ruleset instead of `WordPress` in `phpcs.xml`.

## Plugin Check

CI runs the official Plugin Check (the WordPress.org review rules: security, escaping, i18n, readme, forbidden functions, file types) against the built release folder, not against your dev tree. It only runs when the repo root has a plugin header. To run it locally, install the Plugin Check plugin in wp-env and run `wp plugin check <slug>`.

## License

MIT (see LICENSE). The LICENSE file is not copied into projects by `bin/install.sh`.

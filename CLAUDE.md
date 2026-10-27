# Project context for Claude

> Fill in the TODO lines once per project. Keep this file short; link to docs/ for detail.

## Project

- Name: TODO
- Type: TODO (plugin / theme / full site / block theme)
- Purpose: TODO (one sentence)
- Text domain: TODO | Global prefix: TODO

## Stack

- WordPress TODO+ | PHP TODO+ | Node 20
- Local env: `@wordpress/env` (`npm run env:start`, site on http://localhost:8888)
- Tests: PHPUnit (wp-env), Playwright for e2e

## Commands

| Task | Command |
| --- | --- |
| Install | `composer install && npm install` |
| Lint (WPCS) | `composer lint` (autofix: `composer lint:fix`) |
| Static analysis | `composer analyse` |
| Lint + analysis | `composer check` |
| PHP tests | `npm run test:php` |
| E2E tests | `npm run test:e2e` |

## Conventions

- Follow WordPress Coding Standards (see `phpcs.xml`). Prefix every global.
- Sanitize input early, escape output late. Verify nonce and capability on every state change.
- Use `$wpdb->prepare()` for SQL. Prefer core APIs (WP_Query, options, transients) over raw SQL.
- REST routes always set a real `permission_callback`.
- All user-facing strings go through i18n functions with the project text domain.
- Do not edit WordPress core, `vendor/`, `node_modules/` or built assets by hand.
- Never commit secrets, `.env`, database dumps or uploads.

## Workflow

- Branch from `main`: `feat/...`, `fix/...`, `chore/...`. Small PRs, squash merge.
- Commit messages: Conventional Commits (`feat(scope): subject`).
- Before saying a task is done: run `composer check` and the relevant tests, and report the result.
- Architectural decisions go into `docs/DECISIONS.md` as a short ADR.

## Definition of done

See `docs/SDLC.md`. In short: code reviewed, checks green, tests cover the change, docs updated, deployable from `main`.

## Slash commands and agents

- `/plan <task>` plan before coding
- `/review` review current branch (code + security)
- `/release <patch|minor|major>` prepare a release
- Agents: `code-reviewer`, `security-reviewer`, `a11y-seo-auditor`
- Skills: `wp-plugin-scaffold`, `wp-safe-migration`

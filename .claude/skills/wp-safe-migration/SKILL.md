---
name: wp-safe-migration
description: Write safe database schema changes and data migrations for WordPress plugins/themes - versioned, idempotent, batched, with a rollback plan. Use when changing custom tables, options or post meta structure, or backfilling data.
---

# Safe WordPress migrations

## Principles

- Versioned: store `{prefix}_db_version`. On `plugins_loaded` (or `admin_init`), compare with the code version and run only the missing migrations, in order.
- Idempotent: running a migration twice must not break anything or duplicate data. Check before you write.
- Schema via `dbDelta()` (exact formatting rules apply: two spaces after `PRIMARY KEY`, one field per line). Never `DROP` in the same release that stops using a column - drop in a later release.
- Large data: process in batches (for example 200 rows), store a cursor, continue via Action Scheduler or WP-Cron. Never loop over all posts in one request.
- Multisite: run per blog or network-wide on purpose, not by accident.
- Always take a backup before running on production (`wp db export`). State how to roll back in the PR.

## Steps to follow

1. Describe the change and the old/new shape of the data.
2. Write the migration as a class with `version()`, `up()` and, where possible, `down()`. Register it in an ordered list.
3. Add a PHPUnit test that creates old-shape data, runs `up()` twice, and asserts the result.
4. Add a dry-run mode (log what would change) usable from WP-CLI: `wp yourprefix migrate --dry-run`.
5. Note the deploy order in the PR description: code first or migration first, and whether the site must be in maintenance mode.
